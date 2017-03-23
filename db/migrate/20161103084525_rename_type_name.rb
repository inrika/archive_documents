class RenameTypeName < ActiveRecord::Migration[5.0]
  def change
    rename_column :documents, :type, :doc_type
  end
end
