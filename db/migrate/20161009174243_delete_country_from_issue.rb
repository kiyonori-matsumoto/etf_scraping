class DeleteCountryFromIssue < ActiveRecord::Migration
  def change
    remove_column :issues, :country
    remove_column :issues, :etf_type
  end
end
