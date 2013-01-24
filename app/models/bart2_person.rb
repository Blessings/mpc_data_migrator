class Bart2Person < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'
end
