class CreateBart2PersonAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :bart2_person_attribute_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_person_attribute_types
  end
end
