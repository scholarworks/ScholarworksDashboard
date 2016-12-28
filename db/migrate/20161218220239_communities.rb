class Communities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.references :parent, index: true
      t.string :name
    end

    create_table :collections do |t|
      t.belongs_to :community
      t.string :name
    end
  end
end
