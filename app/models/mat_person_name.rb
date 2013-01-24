class MatPersonName < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_name'
  self.primary_key = 'person_name_id'
end
