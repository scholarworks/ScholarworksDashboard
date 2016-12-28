class AddSizeToBitstream < ActiveRecord::Migration[5.0]
  def change
    add_column :bitstreams, :size_bytes, :integer
    add_column :bitstreams, :deleted, :boolean
  end
end
