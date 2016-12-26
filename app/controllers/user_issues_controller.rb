class UserIssuesController < ApplicationController

  before_action :authenticate_user!
  protect_from_forgery except: :chart

  def index
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

  def chart
    @chart = current_user.user_issue
      .where(bought_day: [Date.today.beginning_of_year..Date.today])
      .order(bought_day: :asc)
      .inject(Hash.new(0)) {|a, e| a[e[:bought_day].to_date] += e[:price] * e[:num]; a}
    @chart += current_user.user_investments
      .where(bought_day: [Date.today.beginning_of_year..Date.today])
      .order(bought_day: :asc)
      .inject(Hash.new(0)) {|a, e| a[e[:bought_day].to_date] += e[:price]; a}
    # @chart = @chart.inject([]){ |a, e| a << e; a }
    totals = 0
    @chart = (Date.today.beginning_of_year..Date.today).map { |e| totals += @chart[e]; [e, @chart[e], totals] }

    respond_to do |format|
      format.js
    end
  end

  def new
    @user_issue = UserIssue.new issue_code: params[:code], price: params[:price], num: params[:num]
    @issues = Issue.all.order(code: :asc).pluck(:name, :code).map { |e| ["#{e[0]}[#{e[1]}]", e[1]] }
  end

  def create
    user_issue = current_user.user_issue.new(user_issue_params)
    user_issue.bought_day = Date.today

    if user_issue.save
      redirect_to user_issues_path
    else
      flash[:danger] = "failed to create"
      render 'new'
    end
  end

  private

  def user_issue_params
    params.require(:user_issue).permit(:issue_code, :num, :price)
  end

end
