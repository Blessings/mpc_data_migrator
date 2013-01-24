class CreateAncPersonAttributes < ActiveRecord::Migration
  def self.up
    create_table :anc_person_attributes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_person_attributes
  end
end
