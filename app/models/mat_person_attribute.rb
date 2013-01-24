class MatPersonAttribute < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_attribute'
  self.primary_key = 'person_attribute_id'
end
