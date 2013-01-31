LogErr = Logger.new(Rails.root.join("log","error.txt"))
class PersonNameCode < ActiveRecord::Base
  belongs_to :person, :foreign_key => :id
  def self.create_name_code(person)
    found = self.find_by_person_id(person.id)
    if found.blank?
      self.create!(:person_id => person.id,
                :given_name_code => (person.given_name || '').soundex,
                :family_name_code => (person.family_name ||'').soundex) rescue LogErr.error person.id
    else
      found.given_name_code = (person.given_name || '').soundex
      found.family_name_code = (person.family_name ||'').soundex
      found.save! rescue LogErr.error person.id
    end           
  end

  def self.rebuild_person_name_codes
    PersonNameCode.delete_all
    people = Person.find(:all)
    people.each {|person|
      PersonNameCode.create(
        :person_id => person.id,
        :given_name_code => (person.given_name || '').soundex,
        :family_name_code => (person.family_name || '').soundex
      )
    }
  end
  
end
