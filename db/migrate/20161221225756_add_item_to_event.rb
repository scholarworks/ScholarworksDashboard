class AddItemToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :item, foreign_key: true
    add_reference :events, :bitstream, foreign_key: true
    add_column :events, :isbot, :boolean
  end
end
