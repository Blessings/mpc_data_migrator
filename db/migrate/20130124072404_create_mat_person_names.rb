class CreateMatPersonNames < ActiveRecord::Migration
  def self.up
    create_table :mat_person_names do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_person_names
  end
end
