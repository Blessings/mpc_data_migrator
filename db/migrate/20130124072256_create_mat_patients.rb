class CreateMatPatients < ActiveRecord::Migration
  def self.up
    create_table :mat_patients do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_patients
  end
end
