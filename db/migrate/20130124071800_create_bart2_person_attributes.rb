class CreateBart2PersonAttributes < ActiveRecord::Migration
  def self.up
    create_table :bart2_person_attributes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_person_attributes
  end
end
