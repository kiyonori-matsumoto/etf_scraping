class UserHomesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user_issues = UserIssueService.user_issues_total_having(current_user)
    @user_investments = UserInvestmentService.user_investments_total_having(current_user)
    @v = {}
    [:current_profit, :total_paid, :current_price].each do |d|
      @v[d] = @user_issues.inject(0) { |a, e| a + e[1][d] } +
              @user_investments.inject(0) { |a, e| a + e[1][d] }
    end
    @v[:year_deposit] = current_user.user_setting.yearly_deposit *
                      UserSettingService.passed_date_first_year(current_user)
    @v[:current_profit_rate] = @v[:current_price] / @v[:total_paid] - 1
  end
end
