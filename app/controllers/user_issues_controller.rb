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

  end

end
