class AncPerson < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'

  has_one :patient,:class_name => 'AncPatient',:foreign_key => :patient_id, :dependent => :destroy, :conditions => {:voided => 0}
  has_many :names, :class_name => 'AncPersonName', :foreign_key => :person_id, :dependent => :destroy, :order => 'person_name.preferred DESC', :conditions => {:voided => 0}
  has_many :addresses, :class_name => 'AncPersonAddress', :foreign_key => :person_id, :dependent => :destroy, :order => 'person_address.preferred DESC', :conditions => {:voided => 0}
  has_many :person_attributes, :class_name => 'AncPersonAttribute', :foreign_key => :person_id, :conditions => {:voided => 0}
  
  
end
