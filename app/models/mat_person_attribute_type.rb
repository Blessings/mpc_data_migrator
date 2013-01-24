class MatPersonAttributeType < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_attribute_type'
  self.primary_key = 'person_attribute_type_id'
  has_many :person_attributes, :class_name => 'MatPersonAttribute', :conditions => {:voided => 0}
end
