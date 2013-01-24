class Bart2Users < ActiveRecord::Base
  establish_connection "openmrs_bart2_#{Rails.env}"
  self.table_name = 'users'
  self.primary_key = 'user_id'
end
