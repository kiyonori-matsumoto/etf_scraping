class ChangePortfolioDefaultofUserSetting < ActiveRecord::Migration
  def change
    change_column_default :user_settings, :japan_issue, 0
    change_column_default :user_settings, :japan_reit, 0
    change_column_default :user_settings, :japan_bond, 0
    change_column_default :user_settings, :developed_issue, 0
    change_column_default :user_settings, :developed_reit, 0
    change_column_default :user_settings, :developed_bond, 0
    change_column_default :user_settings, :emerging_issue, 0
    change_column_default :user_settings, :emerging_reit, 0
    change_column_default :user_settings, :emerging_bond, 0
    change_column_default :user_settings, :commodity, 0
  end
end
