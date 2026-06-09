@EndUserText.label : 'Employee Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zemployee {
  key client      : abap.clnt not null;
  key employee_id : abap.char(10) not null;
  first_name      : abap.char(40);
  last_name       : abap.char(40);
  email           : abap.char(100);
  department      : abap.char(40);
  position        : abap.char(40);
  hire_date       : abap.dats;
  salary          : abap.dec(13,2);
  is_active       : abap_boolean;
  created_by      : syuname;
  created_at      : timestampl;
  last_changed_by : syuname;
  last_changed_at : timestampl;
  local_last_changed_at : timestampl;
}
