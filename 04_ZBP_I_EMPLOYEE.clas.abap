CLASS zbp_i_employee DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zi_employee.

ENDCLASS.

CLASS zbp_i_employee IMPLEMENTATION.
ENDCLASS.

"================================================
" Local handler class (in the same include: LZBP_I_EMPLOYEEAU01)
"================================================
CLASS lhc_employee DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR employee RESULT result.

    METHODS validateEmail     FOR VALIDATE ON SAVE
      IMPORTING keys FOR employee~validateemail.

    METHODS validateHireDate  FOR VALIDATE ON SAVE
      IMPORTING keys FOR employee~validatehiredate.

    METHODS setDefaultValues  FOR DETERMINE ON MODIFY
      IMPORTING keys FOR employee~setdefaultvalues.

    METHODS deactivateEmployee FOR MODIFY
      IMPORTING keys FOR ACTION employee~deactivateemployee RESULT result.

    METHODS activateEmployee   FOR MODIFY
      IMPORTING keys FOR ACTION employee~activateemployee RESULT result.

ENDCLASS.

CLASS lhc_employee IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Allow all operations for simplicity; add custom auth checks here
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      APPEND VALUE #(
        %tky                       = <key>-%tky
        %update                    = if_abap_behv=>auth-allowed
        %delete                    = if_abap_behv=>auth-allowed
        %action-deactivateEmployee = if_abap_behv=>auth-allowed
        %action-activateEmployee   = if_abap_behv=>auth-allowed
      ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmail.
    READ ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        FIELDS ( email )
        WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    LOOP AT employees ASSIGNING FIELD-SYMBOL(<emp>).
      IF <emp>-email IS INITIAL
      OR NOT <emp>-email CP '*@*.*'.
        APPEND VALUE #(
          %tky        = <emp>-%tky
          %state_area = 'VALIDATE_EMAIL'
        ) TO reported-employee.

        APPEND VALUE #(
          %tky = <emp>-%tky
        ) TO failed-employee.

        APPEND VALUE #(
          %tky        = <emp>-%tky
          %state_area = 'VALIDATE_EMAIL'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Email address is not valid' )
        ) TO reported-employee.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateHireDate.
    READ ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        FIELDS ( hiredate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT employees ASSIGNING FIELD-SYMBOL(<emp>).
      IF <emp>-hiredate IS INITIAL.
        APPEND VALUE #(
          %tky        = <emp>-%tky
          %state_area = 'VALIDATE_HIREDATE'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Hire date must not be empty' )
        ) TO reported-employee.

        APPEND VALUE #( %tky = <emp>-%tky ) TO failed-employee.

      ELSEIF <emp>-hiredate > today.
        APPEND VALUE #(
          %tky        = <emp>-%tky
          %state_area = 'VALIDATE_HIREDATE'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-warning
                          text     = 'Hire date is in the future' )
        ) TO reported-employee.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setDefaultValues.
    READ ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        FIELDS ( isactive salary )
        WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    MODIFY ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        UPDATE FIELDS ( isactive salary )
        WITH VALUE #(
          FOR <emp> IN employees
            WHERE ( isactive IS INITIAL )
            ( %tky     = <emp>-%tky
              isactive = abap_true
              salary   = COND #( WHEN <emp>-salary IS INITIAL THEN '0.00'
                                  ELSE <emp>-salary ) )
        )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD deactivateEmployee.
    MODIFY ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        UPDATE FIELDS ( isactive )
        WITH VALUE #(
          FOR key IN keys
            ( %tky     = key-%tky
              isactive = abap_false )
        )
      FAILED   DATA(update_failed)
      REPORTED DATA(update_reported).

    failed   = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    result = VALUE #(
      FOR <emp> IN employees
        ( %tky   = <emp>-%tky
          %param = <emp> )
    ).
  ENDMETHOD.

  METHOD activateEmployee.
    MODIFY ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        UPDATE FIELDS ( isactive )
        WITH VALUE #(
          FOR key IN keys
            ( %tky     = key-%tky
              isactive = abap_true )
        )
      FAILED   DATA(update_failed)
      REPORTED DATA(update_reported).

    failed   = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zi_employee IN LOCAL MODE
      ENTITY employee
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    result = VALUE #(
      FOR <emp> IN employees
        ( %tky   = <emp>-%tky
          %param = <emp> )
    ).
  ENDMETHOD.

ENDCLASS.

"================================================
" Saver class (for managed with additional save)
"================================================
CLASS lsc_zi_employee DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
ENDCLASS.

CLASS lsc_zi_employee IMPLEMENTATION.
  METHOD finalize.     ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD save.         ENDMETHOD.
  METHOD cleanup.      ENDMETHOD.
ENDCLASS.
