class CreateBart2Users < ActiveRecord::Migration
  def self.up
    create_table :bart2_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bart2_users
  end
end
