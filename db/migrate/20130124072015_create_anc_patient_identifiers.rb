class CreateAncPatientIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :anc_patient_identifiers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_patient_identifiers
  end
end
