class CreateBart2PatientIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :bart2_patient_identifiers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_patient_identifiers
  end
end
