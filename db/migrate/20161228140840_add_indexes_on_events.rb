class AddIndexesOnEvents < ActiveRecord::Migration[5.0]
  def change
    add_index :events, [:event_date, :isbot]
    add_index :events, [:event_date, :event_type, :isbot]
  end
end
