class AncPersonAttributeType < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person_attribute_type'
  self.primary_key = 'person_attribute_type_id'
end
