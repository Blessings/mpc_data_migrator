class Bart2PatientIdentifier < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'patient_identifier'
  self.primary_key = 'patient_identifier_id'
  belongs_to :patient, :class_name => "Bart2Patient",
             :foreign_key => :patient_id, :conditions => {:voided => 0}
end
