class AddBitstream < ActiveRecord::Migration[5.0]
  def change
    create_table :bitstreams do |t|
      t.belongs_to :item
      t.string :name
    end

  end
end
