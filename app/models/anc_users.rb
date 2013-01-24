class AncUsers < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'users'
  self.primary_key = 'user_id'
end
