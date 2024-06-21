class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_type
      t.text :event_data
      t.references :eventable, polymorphic: true, null: false
      t.timestamps
    end

    add_index :events, [:eventable_type, :eventable_id]
  end
end