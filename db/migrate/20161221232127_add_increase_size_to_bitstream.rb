class AddIncreaseSizeToBitstream < ActiveRecord::Migration[5.0]
  def change
    change_column :bitstreams, :size_bytes, :integer, :limit => 12
  end
end
