class Person < ActiveRecord::Base
  establish_connection "openmrs_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'
end
