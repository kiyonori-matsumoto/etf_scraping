class AddIssuePriceValuesToDailies < ActiveRecord::Migration
  def change
    add_column :dailies, :start_price, :decimal
    add_column :dailies, :high_price, :decimal
    add_column :dailies, :low_price, :decimal
    rename_column :dailies, :issue_price, :end_price
  end
end
