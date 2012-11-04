class ChangeConversionDefault < ActiveRecord::Migration
  def change
    change_column_default :conversions, :formatted_xml_data, ""
  end
end
