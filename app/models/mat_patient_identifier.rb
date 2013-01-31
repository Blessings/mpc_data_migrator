class MatPatientIdentifier < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'patient_identifier'
  self.primary_key = 'patient_id'
  belongs_to :patient, :class_name => "MatPatient",
             :foreign_key => :patient_id, :conditions => {:voided => 0}
end
