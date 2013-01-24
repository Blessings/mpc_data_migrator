class Bart2Patient < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'patient'
  self.primary_key = 'patient_id'
  has_many :bart2_patient_identifiers, :foreign_key => :patient_id,
      :dependent => :destroy, :conditions => {:voided => 0}
end
