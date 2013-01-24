class CreateBart2Patients < ActiveRecord::Migration
  def self.up
    create_table :bart2_patients do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_patients
  end
end
