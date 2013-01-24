class Bart2PersonName < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person_name'
  self.primary_key = 'person_name_id'
end
