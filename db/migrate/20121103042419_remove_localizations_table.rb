class RemoveLocalizationsTable < ActiveRecord::Migration
  def up
   drop_table :localizations
  end
end
