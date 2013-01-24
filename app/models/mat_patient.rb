class MatPatient < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'patient'
  self.primary_key = 'patient_id'
  has_one :person, :class_name => 'MatPerson', :foreign_key => :person_id, :conditions => {:voided => 0}
  has_many :patient_identifiers, :class_name => 'MatPatientIdentifier' , :foreign_key => :patient_id,
      :dependent => :destroy, :conditions => {:voided => 0,:identifier_type => 3}
end
