module MigrationClasses
  class AncPatient < Patient
    establish_connection "openmrs_anc#{Rails.env}"
    self.table_name = 'patient'
  end

  class Bart2Patient < Patient
    establish_connection "openmrs_bart2#{Rails.env}"
    self.table_name = 'patient'
  end
end
