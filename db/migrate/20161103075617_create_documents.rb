class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :doc_num
      t.datetime :doc_date
      t.string :type
      t.text :content
      t.string :branch
      t.string :geography
      t.string :office
      t.string :fund
      t.string :inventory
      t.integer :storage_unit
      t.string :page
      t.string :note

      t.timestamps
    end
  end
end
