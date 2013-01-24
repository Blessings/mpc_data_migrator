class CreateMatPatientIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :mat_patient_identifiers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_patient_identifiers
  end
end
