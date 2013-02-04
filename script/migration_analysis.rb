LogCommonIds = Logger.new(Rails.root.join("log","common_ids.txt"))
LogDiffIds = Logger.new(Rails.root.join("log","diff_ids.txt"))
LogBartOnlyIds = Logger.new(Rails.root.join("log","bart_only_ids.txt"))
LogMatOnlyIds = Logger.new(Rails.root.join("log","mat_only_ids.txt"))
LogTimeandCounts = Logger.new(Rails.root.join("log","time_and_counts.txt"))

# Select all people from model that are females and count them
def get_people(personmodel,name)
  log_progress("Searching for #{name} female patients from :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  people = personmodel.where(:voided => 0,:gender => "F")
  log_progress("Finished searching for #{name} female patients at:#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("Found ##{personmodel.count} female patients in #{name}",true)
  return people
end

#Get all people that are patients
def get_patients(people)
  patients = []
  people.each do |person|
    patients << person.patient
  end
  return patients
end


#Analyse demographics
def check_demographics
  
  bart_demographics =  build_demographics(get_people(Bart2Person,"BART 2.0"))
  log_progress("Finished buiding BART demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("There are : ##{bart_demographics.count} patient demographics in BART2",true)
  mat_demographics = build_demographics(get_people(MatPerson,"Martenity"))
  log_progress("Finished buiding MAT demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("There are : ##{mat_demographics.count} patient demographics in MAT",true)
  log_progress("Searching MAT demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)

  common_ids = []
  diff_ids = []
  bart_only_ids = []
  mat_only_ids = []
  bart_demographics.each do|key,value|
    next if key.blank?
    unless mat_demographics[key].blank?
      if mat_demographics[key] == value
        common_ids << key
        log_progress("common national patient identifier >>> #{key}")
        LogCommonIds.info key.to_s
      else
        diff_ids << key
        log_progress("found in maternity but for a different person >> #{key}")
        LogDiffIds.info key.to_s
      end
    else
      bart_only_ids << key
      log_progress("not found in maternity > #{key}")
      LogBartOnlyIds.info key.to_s  
    end
  end

  log_progress("Searching BART demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)

  mat_demographics.each do|key,value|
    next if key.blank?
    if bart_demographics[key].blank?
      mat_only_ids << key
      log_progress("not found in bart > #{key}")
      LogMatOnlyIds.info key.to_s
    end
  end
  log_progress("##{common_ids.count} common ids",true)
  log_progress("##{diff_ids.count} different ids",true)
  log_progress("##{bart_only_ids.count} bart only ids",true)
  log_progress("##{mat_only_ids.count} maternity only ids",true)
  log_progress("Finished checking demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
end
# Get patients with identifiers only
def build_demographics(people)
  demographics = {}
  people.each do |person|
    next if person.blank?
    next if person.patient.blank?
    next if person.patient.patient_identifiers.first.blank?
    demographics[person.patient.patient_identifiers.first.identifier] = {"given_name" => person.names.first.given_name.titlecase,
                                                              "family_name" => person.names.first.family_name.titlecase,
                                                              "birthdate" => person.birthdate}
  end
 return demographics
end
# log status of script
def log_progress(message,log=false)
  puts ">>> " + message
  LogTimeandCounts.info message if log == true
end



#get_full_attribute(Bart2Person.last,"Occupation")
#build_dde_person(AncPerson.last)
#check_demographics
get_people(Bart2Person,"BART 2.0")