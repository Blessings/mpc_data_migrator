class MatPatientIdentifierType < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'patient_identifier_type'
  self.primary_key = 'patient_identifier_type_id'
  belongs_to :patient, :class_name => "MatPatient",
             :foreign_key => :patient_id, :conditions => {:voided => 0}
end
