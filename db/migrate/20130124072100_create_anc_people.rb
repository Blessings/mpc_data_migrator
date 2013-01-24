class CreateAncPeople < ActiveRecord::Migration
  def self.up
    create_table :anc_people do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_people
  end
end
