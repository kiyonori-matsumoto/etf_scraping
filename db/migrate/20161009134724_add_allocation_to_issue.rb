class AddAllocationToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :country, :string, null: false, default: ""
    add_column :issues, :etf_type, :string, null: false, default: ""
  end
end
