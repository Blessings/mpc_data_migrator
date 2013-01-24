class CreateAncPatients < ActiveRecord::Migration
  def self.up
    create_table :anc_patients do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_patients
  end
end
