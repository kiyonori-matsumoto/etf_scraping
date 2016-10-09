class AddPortfolioTypeToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :portfolio_type, :string
  end
end
