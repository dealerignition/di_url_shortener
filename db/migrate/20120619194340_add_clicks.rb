class AddClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.integer :short_url_id
      t.string  :ip_address
      t.string  :referrer
      t.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end
