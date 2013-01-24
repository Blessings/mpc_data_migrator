class MatPatient < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'patient'
  self.primary_key = 'patient_id'
  has_many :mat_patient_identifiers, :foreign_key => :patient_id,
      :dependent => :destroy, :conditions => {:voided => 0}
end
