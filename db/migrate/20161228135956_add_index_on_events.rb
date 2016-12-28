class AddIndexOnEvents < ActiveRecord::Migration[5.0]
  def change
    add_index :events, :event_date
    add_index :events, :event_type
  end
end
