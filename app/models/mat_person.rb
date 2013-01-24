class MatPerson < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person'
  self.primary_key = 'person_id'
end
