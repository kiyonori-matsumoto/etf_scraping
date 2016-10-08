class UserIssuesController < ApplicationController

  before_action :authenticate_user!

  def index
    # @user_issues = current_user.user_issue.joins(:issue).select(%w(user_issues.* issues.*))
    # @user_issues = current_user.user_issue.group(:issue_code).select('issue_code, max(bought_day) as maximum_bought_day, sum(num) as total')
    @user_issues = current_user.user_issue.group(:issue_code).maximum(:bought_day)

    @user_issues_total = current_user.user_issue.group(:issue_code).sum(:num)

    @issues = Issue.group(:code).select([:code, :name])

    @average_price = current_user.user_issue
      .inject(Hash.new(0)){ |a, e| a[e[:issue_code]] += e[:price] * e[:num]; a }

    @average_price = Hash[@average_price.map { |e| e[1] /= @user_issues_total[e[0]]; e }]

    subquery = Daily.group(:issue_code).maximum(:created_at)
    @prices = Daily.where(created_at: subquery.values).group(:issue_code).sum(:end_price)
    @prices.default = 0

  end

  def new
    @user_issue = UserIssue.new issue_code: params[:code], price: params[:price], num: params[:num]
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
