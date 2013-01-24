class CreateAncPatientIdentifierTypes < ActiveRecord::Migration
  def self.up
    create_table :anc_patient_identifier_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_patient_identifier_types
  end
end
