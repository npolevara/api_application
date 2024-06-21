class AddStatusToApplicationAndJob < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :status, :string, default: "applied"
    add_column :jobs, :status, :string, default: "deactivated"
  end
end
