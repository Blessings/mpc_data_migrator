class Bart2PersonAddress < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person_address'
  self.primary_key = 'person_address_id'
  belongs_to :person, :class_name => 'Bart2Person', :foreign_key => :person_id, :conditions => {:voided => 0}
end
