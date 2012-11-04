class AddDescriptionToConversions < ActiveRecord::Migration
  def change
    add_column :conversions, :description, :text, default: ""
  end
end
