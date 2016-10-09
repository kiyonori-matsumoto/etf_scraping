class AddPortforioToUserSetting < ActiveRecord::Migration
  def change
    add_column :user_settings, :japan_issue, :integer
    add_column :user_settings, :japan_reit, :integer
    add_column :user_settings, :japan_bond, :integer
    add_column :user_settings, :developed_issue, :integer
    add_column :user_settings, :developed_reit, :integer
    add_column :user_settings, :developed_bond, :integer
    add_column :user_settings, :emerging_issue, :integer
    add_column :user_settings, :emerging_reit, :integer
    add_column :user_settings, :emerging_bond, :integer
    add_column :user_settings, :commodity, :integer
  end
end
