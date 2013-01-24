class AncPatientIdentifier < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'patient_identifier'
  self.primary_key = 'patient_identifier_id'
  belongs_to :anc_patient, :class_name => "AncPatient",
             :foreign_key => :patient_id, :conditions => {:voided => 0}
end
