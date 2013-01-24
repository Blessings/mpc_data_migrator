class Bart2Patient < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'patient'
  self.primary_key = 'patient_id'
  has_one :person, :class_name => 'Bart2Person', :foreign_key => :person_id, :conditions => {:voided => 0}
  has_many :patient_identifiers, :class_name => 'Bart2PatientIdentifier' , :foreign_key => :patient_id,
      :dependent => :destroy, :conditions => {:voided => 0,:identifier_type => 3}
end
