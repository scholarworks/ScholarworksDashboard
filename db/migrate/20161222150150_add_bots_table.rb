class AddBotsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :bots do |t|
      t.string :ip_addr
    end
  end
end
