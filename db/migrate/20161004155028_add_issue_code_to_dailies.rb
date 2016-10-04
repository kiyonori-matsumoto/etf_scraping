class AddIssueCodeToDailies < ActiveRecord::Migration
  def change
    add_column :dailies, :issue_code, :string
  end
end
