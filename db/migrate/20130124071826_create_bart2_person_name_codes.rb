class CreateBart2PersonNameCodes < ActiveRecord::Migration
  def self.up
    create_table :bart2_person_name_codes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_person_name_codes
  end
end
