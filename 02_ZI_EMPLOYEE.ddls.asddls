@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee - Interface View'
define root view entity ZI_EMPLOYEE
  as select from zemployee
{
  key employee_id          as EmployeeId,
      first_name           as FirstName,
      last_name            as LastName,
      email                as Email,
      department           as Department,
      position             as Position,
      hire_date            as HireDate,
      salary               as Salary,
      is_active            as IsActive,

      @Semantics.user.createdBy: true
      created_by           as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at           as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
