class MatPatientIdentifierType < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'patient_identifier_type'
  self.primary_key = 'patient_identifier_type_id'
end
