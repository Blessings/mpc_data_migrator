class CreateAncPersonAddresses < ActiveRecord::Migration
  def self.up
    create_table :anc_person_addresses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_person_addresses
  end
end
