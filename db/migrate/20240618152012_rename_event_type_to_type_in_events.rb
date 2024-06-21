class RenameEventTypeToTypeInEvents < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :event_type, :type
    change_column_null :events, :type, false
  end
end
