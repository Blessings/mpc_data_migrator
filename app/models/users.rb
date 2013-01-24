class Users < ActiveRecord::Base
  establish_connection "openmrs_#{Rails.env}"
  self.table_name = 'users'
  self.primary_key = 'user_id'
end
