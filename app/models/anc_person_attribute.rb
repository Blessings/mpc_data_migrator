class AncPersonAttribute < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person_attribute'
  self.primary_key = 'person_attribute_id'
end
