class CreateBart2PatientIdentifierTypes < ActiveRecord::Migration
  def self.up
    create_table :bart2_patient_identifier_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_patient_identifier_types
  end
end
