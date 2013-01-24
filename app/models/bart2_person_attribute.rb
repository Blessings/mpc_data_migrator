class Bart2PersonAttribute < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person_attribute'
  self.primary_key = 'person_attribute_id'
  belongs_to :type, :class_name => "Bart2PersonAttributeType", :foreign_key => :person_attribute_type_id, :conditions => {:retired => 0}
  belongs_to :person,:class_name => "Bart2Person", :foreign_key => :person_id, :conditions => {:voided => 0}
end
