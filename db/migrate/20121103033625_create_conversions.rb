class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.string :author
      t.string :csv_file
      t.text :formatted_xml

      t.timestamps
    end
  end
end
