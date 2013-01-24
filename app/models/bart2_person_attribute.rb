class Bart2PersonAttribute < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person_attribute'
  self.primary_key = 'person_attribute_id'
end
