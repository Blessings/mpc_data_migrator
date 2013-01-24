class AncPerson < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'
end
