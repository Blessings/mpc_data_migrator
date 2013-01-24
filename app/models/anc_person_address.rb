class AncPersonAddress < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person_address'
  self.primary_key = 'person_address_id'
end
