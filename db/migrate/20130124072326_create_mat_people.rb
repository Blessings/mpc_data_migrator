class CreateMatPeople < ActiveRecord::Migration
  def self.up
    create_table :mat_people do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_people
  end
end
