class AddItem < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.belongs_to :collection
      t.string :handle
    end
  end
end
