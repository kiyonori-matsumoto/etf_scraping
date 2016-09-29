class AddCompanyToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :company, :string
  end
end
