class CreateMatPersonAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :mat_person_attribute_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_person_attribute_types
  end
end
