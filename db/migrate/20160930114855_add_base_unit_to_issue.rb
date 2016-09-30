class AddBaseUnitToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :base_unit, :integer, default: 1
    add_column :issues, :trade_unit, :integer, default: 1
  end
end
