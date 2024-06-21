class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.references :job, null: false, foreign_key: true
      t.string :candidate_name, null: false

      t.timestamps
    end
  end
end
