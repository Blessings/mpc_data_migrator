

class DdeMigration
  def initialize
    
  end
  def self.get_patient_identifiers
    bart2_patient_identifiers = Bart2PatientIdentifier.limit(100)
    bart2_patient_identifiers.each do |patient_identifier|
      next if patient_identifier.blank?
      next if patient_identifier.patient.blank?
      next if patient_identifier.patient.person.blank?
      person = patient_identifier.patient.person
      person_params = self.build_dde_person(person)
      self.create_person_on_dde(person_params)
    end
  end

  def self.build_dde_person(person)
  current_person = {"person" => {
              "birthdate_estimated" => (person.birthdate_estimated rescue nil),
              "gender" => (person.gender rescue nil),
              "birthdate" => (person.birthdate rescue nil),
              "birth_year" => (person.birthdate.to_date.year rescue nil),
              "birth_month" => (person.birthdate.to_date.month rescue nil),
              "birth_day" => (person.birthdate.to_date.date rescue nil),
              "names" => {
                "given_name" => person.names.first.given_name,
                "family_name" => person.names.first.family_name
              },
              "patient" => {
                "identifiers" => {
                  "old_identification_number" => person.patient.patient_identifiers.first.identifier
                }
              },
              "attributes" => {
                "occupation" => (get_full_attribute(person, "Occupation") rescue nil),
                "cell_phone_number" => (get_full_attribute(person, "Cell Phone Number") rescue nil),
                "citizenship" => (get_full_attribute(person, "Citizenship") rescue nil),
                "race" => (get_full_attribute(person, "Race") rescue nil)
              },
              "addresses" => {
                "address1" => (person.addresses.last.current_address1 rescue nil),
                "city_village" => (person.addresses.last.city_village rescue nil),
                "address2" => (person.addresses.last.current_address2 rescue nil),
                "subregion" => (person.addresses.last.subregion rescue nil),
                "county_district" => (person.addresses.last.county_district rescue nil),
                "neighborhood_cell" => (person.addresses.last.neighborhood_cell rescue nil)
              }
            }
          }
  return self.build_person_for_dde(current_person)
end

def self.create_person_on_dde(params)
  passed_national_id = (params['person']['data']['patient']['identifiers']['old_identification_number'])
  national_id = passed_national_id.gsub('-','').strip unless passed_national_id.blank?
  version = Guid.new.to_s
    @person = Person.new(params['person'].merge(
                         {:creator_site_id => Site.current_id ,
                         :given_name => params["person"]["data"]["names"]["given_name"] ,
                         :family_name => params["person"]["data"]["names"]["family_name"] ,
                         :gender => params["person"]["data"]["gender"] ,
                         :birthdate => params["person"]["data"]["birthdate"] ,
                         :birthdate_estimated => params["person"]["data"]["birthdate_estimated"],
                         :version_number => version,
                         :remote_version_number => version }
                        ))
     if @person.save
        unless passed_national_id.blank?
          legacy_national_id = LegacyNationalIds.new()
          legacy_national_id.person_id = @person.id
          legacy_national_id.value = national_id
          legacy_national_id.save
        end
     end
end

def self.build_person_for_dde(params)
	  address_params = params["person"]["addresses"]
		names_params = params["person"]["names"]
		patient_params = params["person"]["patient"]
    birthday_params = params["person"]
		params_to_process = params.reject{|key,value|
      key.match(/identifiers|addresses|patient|names|relation|cell_phone_number|home_phone_number|office_phone_number|agrees_to_be_visited_for_TB_therapy|agrees_phone_text_for_TB_therapy/)
    }
		birthday_params = params_to_process["person"].reject{|key,value| key.match(/gender/) }
		person_params = params_to_process["person"].reject{|key,value| key.match(/birth_|age_estimate|occupation/) }


		if person_params["gender"].to_s == "Female"
      person_params["gender"] = 'F'
		elsif person_params["gender"].to_s == "Male"
      person_params["gender"] = 'M'
		end

		unless birthday_params.empty?
		  if birthday_params["birth_year"] == "Unknown"
			  birthdate = Date.new(Date.today.year - birthday_params["age_estimate"].to_i, 7, 1)
        birthdate_estimated = 1
		  else
			  year = birthday_params["birth_year"]
        month = birthday_params["birth_month"]
        day = birthday_params["birth_day"]

        month_i = (month || 0).to_i
        month_i = Date::MONTHNAMES.index(month) if month_i == 0 || month_i.blank?
        month_i = Date::ABBR_MONTHNAMES.index(month) if month_i == 0 || month_i.blank?

        if month_i == 0 || month == "Unknown"
          birthdate = Date.new(year.to_i,7,1)
          birthdate_estimated = 1
        elsif day.blank? || day == "Unknown" || day == 0
          birthdate = Date.new(year.to_i,month_i,15)
          birthdate_estimated = 1
        else
          birthdate = Date.new(year.to_i,month_i,day.to_i)
          birthdate_estimated = 0
        end
		  end
    else
      birthdate_estimated = 0
		end

    passed_params = {"person"=>
        {"data" =>
          {"addresses"=>
            {"state_province"=> (address_params["address2"] rescue ""),
            "address2"=> (address_params["address1"] rescue ""),
            "city_village"=> (address_params["city_village"] rescue ""),
            "county_district"=> (address_params["county_district"] rescue "")
          },
          "attributes"=>
            {"occupation"=> (params["person"]["occupation"] rescue ""),
            "cell_phone_number" => (params["person"]["cell_phone_number"] rescue ""),
            "citizenship" => (params["person"]["citizenship"] rescue ""),
            "race" => (params["person"]["race"] rescue "")
          },
          "patient"=>
            {"identifiers"=>
              {"old_identification_number" => params["person"]["patient"]["identifiers"]["old_identification_number"]}},
          "gender"=> person_params["gender"],
          "birthdate"=> birthdate,
          "birthdate_estimated"=> birthdate_estimated ,
          "names"=>{"family_name"=> names_params["family_name"],
            "given_name"=> names_params["given_name"]
          }
        }
      }
    }
   return passed_params
end

def self.get_full_attribute(person,attribute)
    attribute_value = person.person_attributes.find(:first,:conditions =>["voided = 0 AND person_attribute_type_id = ? AND person_id = ?",
    Bart2PersonAttributeType.find_by_name(attribute).id,person.id]).value rescue nil
   return attribute_value
end

 self.get_patient_identifiers

end
