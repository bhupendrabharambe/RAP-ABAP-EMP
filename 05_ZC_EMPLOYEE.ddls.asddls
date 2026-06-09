@EndUserText.label: 'Employee - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo: {
  typeName:       'Employee',
  typeNamePlural: 'Employees',
  title:          { type: #STANDARD, value: 'EmployeeId' },
  description:    { type: #STANDARD, value: 'FirstName' }
}

@Search.searchable: true

define root view entity ZC_EMPLOYEE
  provider contract transactional_query
  as projection on ZI_EMPLOYEE
{
      @UI.facet: [
        { id:       'EmployeeInfo',
          purpose:  #STANDARD,
          type:     #IDENTIFICATION_REFERENCE,
          label:    'Employee Information',
          position: 10 },
        { id:       'AdminData',
          purpose:  #STANDARD,
          type:     #FIELDGROUP_REFERENCE,
          targetQualifier: 'AdminData',
          label:    'Administrative Data',
          position: 20 }
      ]

      @UI.lineItem:       [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
  key EmployeeId,

      @UI.lineItem:       [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @Search.defaultSearchElement: true
      FirstName,

      @UI.lineItem:       [{ position: 30, importance: #HIGH }]
      @UI.identification: [{ position: 30 }]
      @Search.defaultSearchElement: true
      LastName,

      @UI.lineItem:       [{ position: 40, importance: #MEDIUM }]
      @UI.identification: [{ position: 40 }]
      Email,

      @UI.lineItem:       [{ position: 50, importance: #MEDIUM }]
      @UI.identification: [{ position: 50 }]
      @UI.selectionField: [{ position: 20 }]
      Department,

      @UI.lineItem:       [{ position: 60, importance: #LOW }]
      @UI.identification: [{ position: 60 }]
      Position,

      @UI.lineItem:       [{ position: 70, importance: #LOW }]
      @UI.identification: [{ position: 70 }]
      HireDate,

      @UI.lineItem:       [{ position: 80, importance: #LOW }]
      @UI.identification: [{ position: 80 }]
      @Semantics.amount.currencyCode: 'USD'
      Salary,

      @UI.lineItem:       [{ position: 90, importance: #MEDIUM,
                             criticality: 'IsActiveCriticality' }]
      @UI.identification: [{ position: 90 }]
      IsActive,

      // Virtual element for criticality coloring
      @UI.hidden: true
      case IsActive
        when abap_true  then 3   " green
        else                 1   " red
      end                        as IsActiveCriticality,

      @UI.fieldGroup: [{ qualifier: 'AdminData', position: 10 }]
      CreatedBy,
      @UI.fieldGroup: [{ qualifier: 'AdminData', position: 20 }]
      CreatedAt,
      @UI.fieldGroup: [{ qualifier: 'AdminData', position: 30 }]
      LastChangedBy,
      @UI.fieldGroup: [{ qualifier: 'AdminData', position: 40 }]
      LastChangedAt,

      LocalLastChangedAt
}
