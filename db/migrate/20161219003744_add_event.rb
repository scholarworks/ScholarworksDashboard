class AddEvent < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.belongs_to :communty
      t.belongs_to :collection
      t.string :session_id
      t.string :ip_addr
      t.string :event_type
      t.string :event_class
      t.string :source
      t.datetime :event_date
    end
  end
end
