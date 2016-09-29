class AddIndexToCodeToIssue < ActiveRecord::Migration
  def change
    add_index :issues, :code, unique: true
  end
end
