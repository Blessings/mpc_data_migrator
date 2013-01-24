class MatUsers < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'users'
  self.primary_key = 'user_id'
end
