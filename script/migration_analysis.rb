LogCommonIds = Logger.new(Rails.root.join("log","common_ids.txt"))
LogDiffIds = Logger.new(Rails.root.join("log","diff_ids.txt"))
LogBartOnlyIds = Logger.new(Rails.root.join("log","bart_only_ids.txt"))
LogMatOnlyIds = Logger.new(Rails.root.join("log","mat_only_ids.txt"))
LogTimeandCounts = Logger.new(Rails.root.join("log","time_and_counts.txt"))


def get_bart_people
  log_progress("Searching for BART2 female patients from :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  people = Bart2Person.where(:voided => 0,:gender => "F")
  log_progress("Finished searching for BART2 female patients at:#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("Found ##{people.count} female patients in BART2",true)
  return people
end

def get_mat_people
  log_progress("Searching for MAT female patients from :#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  people = MatPerson.where(:voided => 0,:gender => "F")
  log_progress("Finished searching for MAT female patients at:#{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("Found ##{people.count} female patients in MAT",true)
  return people
end

def get_patients(people)
  patients = []
  people.each do |person|
    patients << person.patient
  end
  return patients
end

def check_demographics
  
  bart_demographics =  build_demographics(get_bart_people)
  log_progress("Finished buiding BART demographics at: #{Time.now().strftime('%Y-%m-%d %H:%M:%S')}",true)
  log_progress("There are : ##{bart_demographics.count} patient demographics in BART2",true)
  mat_demographics = build_demographics(get_mat_people)
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

def log_progress(message,log=false)
  puts ">>> " + message
  LogTimeandCounts.info message if log == true
end



#get_full_attribute(Bart2Person.last,"Occupation")
build_dde_person(AncPerson.last)
#check_demographics