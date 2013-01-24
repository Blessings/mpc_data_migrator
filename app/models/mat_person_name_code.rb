class MatPersonNameCode < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_name_code'
  self.primary_key = 'person_name_code_id'
end
