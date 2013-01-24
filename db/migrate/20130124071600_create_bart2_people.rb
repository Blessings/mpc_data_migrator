class CreateBart2People < ActiveRecord::Migration
  def self.up
    create_table :bart2_people do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_people
  end
end
