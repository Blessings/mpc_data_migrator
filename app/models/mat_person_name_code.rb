class MatPersonNameCode < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_name_code'
  self.primary_key = 'person_name_code_id'
  belongs_to :person_name,:class_name => 'MatPersonName', :conditions => {:voided => 0}
end
