class ChangeXmlName < ActiveRecord::Migration
  def change
    rename_column :conversions, :formatted_xml, :formatted_xml_data
    add_column :conversions, :formatted_xml_filename, :string, default: ""
  end

end
