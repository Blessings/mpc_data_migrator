class MatPersonAddress < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_address'
  self.primary_key = 'person_address_id'
  belongs_to :person, :class_name => 'MatPerson', :foreign_key => :person_id, :conditions => {:voided => 0}
end
