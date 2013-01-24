class MatPersonName < ActiveRecord::Base
  establish_connection "openmrs_mat_#{Rails.env}"
  self.table_name = 'person_name'
  self.primary_key = 'person_name_id'

  belongs_to :person, :class_name => 'MatPerson', :foreign_key => :person_id, :conditions => {:voided => 0}
  has_one :person_name_code, :class_name => 'MatPersonNameCode', :foreign_key => :person_name_id

  def before_save
    self.build_person_name_code(
      :person_name_id => self.person_name_id,
      :given_name_code => (self.given_name || '').soundex,
      :middle_name_code => (self.middle_name || '').soundex,
      :family_name_code => (self.family_name || '').soundex,
      :family_name2_code => (self.family_name2 || '').soundex,
      :family_name_suffix_code => (self.family_name_suffix || '').soundex)
  end
end
