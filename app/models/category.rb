class Category < ApplicationRecord
  has_many :documents

  def add_documents
    require 'csv'
    CSV.foreach('C:\Sites\archive_documents\bd2.csv',  col_sep: ';', headers: true) do |row|
    #   CSV.foreach('C:\Sites\archive_documents\adm1.csv', col_sep: ';',headers: true) do |row|
      document= Document.new()
      document.doc_num = row[1]
      document.doc_date = row[2]
      document.doc_type = row[0]
      document.content = row[3]
      document.branch = row[4]
      document.geography = row[5]
      document.office = row[6]
      document.fund = row[7]
      document.inventory = row[8]
      document.storage_unit = row[9].to_i
      document.page = row[10]
      document.note = row[11]
      documents << document
      document.save
    end
  end
end
