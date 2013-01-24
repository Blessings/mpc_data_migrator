class Bart2PersonAddress < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'person_address'
end
