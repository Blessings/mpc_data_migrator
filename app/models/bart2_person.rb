class Bart2Person < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'

  has_one :patient,:class_name => 'Bart2Patient',:foreign_key => :patient_id, :dependent => :destroy, :conditions => {:voided => 0}
  has_many :names, :class_name => 'Bart2PersonName', :foreign_key => :person_id, :dependent => :destroy, :order => 'person_name.preferred DESC', :conditions => {:voided => 0}
  has_many :addresses, :class_name => 'Bart2PersonAddress', :foreign_key => :person_id, :dependent => :destroy, :order => 'person_address.preferred DESC', :conditions => {:voided => 0}
  has_many :person_attributes, :class_name => 'Bart2PersonAttribute', :foreign_key => :person_id, :conditions => {:voided => 0}
end
