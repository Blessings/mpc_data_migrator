class AncUsers < ActiveRecord::Base
  establish_connection "openmrs_anc_#{Rails.env}"
  self.table_name = 'users'
  self.primary_key = 'user_id'
  belongs_to :person, :class_name => 'AncPerson', :foreign_key => :person_id, :conditions => {:voided => 0}
end
