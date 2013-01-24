class CreateBart2PersonNames < ActiveRecord::Migration
  def self.up
    create_table :bart2_person_names do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_person_names
  end
end
