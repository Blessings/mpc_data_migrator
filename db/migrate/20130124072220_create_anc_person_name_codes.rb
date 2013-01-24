class CreateAncPersonNameCodes < ActiveRecord::Migration
  def self.up
    create_table :anc_person_name_codes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_person_name_codes
  end
end
