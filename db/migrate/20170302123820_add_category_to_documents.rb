class AddCategoryToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :documents, :category, foreign_key: true
  end
end
