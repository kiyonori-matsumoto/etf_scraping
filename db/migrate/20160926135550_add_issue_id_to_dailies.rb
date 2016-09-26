class AddIssueIdToDailies < ActiveRecord::Migration
  def change
    add_column :dailies, :issue_id, :integer
  end
end
