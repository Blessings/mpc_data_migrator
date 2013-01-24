class AncPersonName < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person_name'
  self.primary_key = 'person_name_id'
end
