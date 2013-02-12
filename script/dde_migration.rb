LogStatus = Logger.new(Rails.root.join("log","migration_status.txt"))
LogVer4 = Logger.new(Rails.root.join("log","version4_ids.txt"))
LogErr = Logger.new(Rails.root.join("log","error.txt"))
class DdeMigration
  def self.get_patient_identifiers
    self.log_progress("Started at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)

    identifier_type = Bart2PatientIdentifierType.where(:name => "National id")
    identifier_type_id =  identifier_type.first.patient_identifier_type_id

    
    mat_common_ids = []
    mat_common_ids = self.read_files("Martenity","bart_mat_common_ids.txt")
    anc_common_ids = []
    anc_common_ids = self.read_files("ANC","bart_anc_common_ids.txt")
    
    self.log_progress("Started searching for BART2  patient identifiers at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    bart2_patient_identifiers = Bart2PatientIdentifier.where(:voided => 0,:identifier_type => identifier_type_id).order(:identifier)
    self.log_progress("Found #{bart2_patient_identifiers.count} BART2 patient identifiers", true)
    self.log_progress("Started searching for maternity patient identifiers at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    mat_patient_identifiers = MatPatientIdentifier.where("identifier NOT IN(?) AND voided = 0 AND identifier_type = ?",mat_common_ids, identifier_type_id).order(:identifier)
    self.log_progress("Found #{mat_patient_identifiers.count} Maternity patient identifiers", true)
    self.log_progress("Started searching for ANC patient identifiers at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    anc_patient_identifiers = AncPatientIdentifier.where("identifier NOT IN(?) AND voided = 0 AND identifier_type = ?",anc_common_ids, identifier_type_id).order(:identifier)
    self.log_progress("Found #{anc_patient_identifiers.count} ANC patient identifiers", true)

    self.log_progress("Started migrating data at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)

    self.log_progress("Started migrating BART2 demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    self.do_migrate(bart2_patient_identifiers)
    self.log_progress("Finished migrating BART2 demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true )
    self.log_progress("Started migrating Maternity demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    self.do_migrate(mat_patient_identifiers)
    self.log_progress("Finished migrating Maternity demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true )
    self.log_progress("Started migrating ANC demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    self.do_migrate(anc_patient_identifiers)
    self.log_progress("Finished migrating ANC demographics at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true )

    self.log_progress("Finished at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  end
  
  def self.do_migrate(patient_identifiers)
    patient_identifiers.each do |patient_identifier|
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
  person_hash = params['person'].merge(
                         {:creator_site_id => Site.current_id ,
                         :given_name => params["person"]["data"]["names"]["given_name"] ,
                         :family_name => params["person"]["data"]["names"]["family_name"] ,
                         :gender => params["person"]["data"]["gender"] ,
                         :birthdate => params["person"]["data"]["birthdate"] ,
                         :birthdate_estimated => params["person"]["data"]["birthdate_estimated"],
                         :version_number => version,
                         :remote_version_number => version }
                        )
    LogVer4.info person_hash and return if national_id.length == 6
    @person = Person.new(person_hash)
     if @person.save!
        unless passed_national_id.blank?
          legacy_national_id = LegacyNationalIds.new()
          legacy_national_id.person_id = @person.id
          legacy_national_id.value = national_id
          legacy_national_id.save! rescue LogErr.error "passed national id " + passed_national_id.to_s
        end
        self.log_progress("migrated ***#{national_id}***")
     else
       LogErr.error "passed national id " + passed_national_id.to_s
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

def self.log_progress(message,log=false)
  puts ">>> " + message
  if log == true
    LogStatus.info message
    LogStatus.info "#" * message.length
  end
  
end

def self.read_files(model_name,file_name)
  self.log_progress("Reading BART 2.0 / #{model_name} common National Identifiers at :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
    common_id_file = File.open(Rails.root.join("log","#{file_name}"))
    common_ids = []
    common_ids_stripped = []
    common_ids = common_id_file.readlines
    common_ids.each do |common_id|
      next if common_id.blank?
      next if common_id.strip.length > 13
      common_ids_stripped << common_id.strip
    end

   self.log_progress("Found #{common_ids_stripped.count} BART 2.0 / #{model_name} common National Identifiers", true)
   return common_ids_stripped
end


# self.get_patient_identifiers

end
