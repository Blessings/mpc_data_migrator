class CreateMatUsers < ActiveRecord::Migration
  def self.up
    create_table :mat_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mat_users
  end
end
