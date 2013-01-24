class CreateAncUsers < ActiveRecord::Migration
  def self.up
    create_table :anc_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :anc_users
  end
end
