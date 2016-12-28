class UserIssuesController < ApplicationController

  before_action :authenticate_user!
  protect_from_forgery except: :chart

  def index
    @user_issues = current_user.user_issues
  end

  def edit
    @user_issue = UserIssue.find_by(id: params[:id])
    @issues = Issue.all.order(code: :asc).pluck(:name, :code).map { |e| ["#{e[0]}[#{e[1]}]", e[1]] }
  end

  def chart
    @chart = current_user.user_issues
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
    @user_issue.bought_day = Date.today
    @issues = Issue.all.order(code: :asc).pluck(:name, :code).map { |e| ["#{e[0]}[#{e[1]}]", e[1]] }
  end

  def create
    user_issue = current_user.user_issues.new(user_issues_params)

    if user_issue.save
      redirect_to user_issues_path
    else
      flash[:danger] = "failed to create"
      render 'new'
    end
  end

  def update
    @user_issue = UserIssue.find_by(id: params[:id])
    if @user_issue.update_attributes(user_issues_params)
      redirect_to user_issues_path
    else
      flash[:danger] = "failed to update"
      render 'edit'
    end
  end

  def destroy
    @user_issue = UserIssue.find_by(id: params[:id])
    if @user_issue && @user_issue.destroy
      flash[:success] = "削除成功"
      redirect_to user_issues_path
    else
      flash[:danger] = "削除失敗"
      redirect_to user_issues_path
    end
  end

  private

  def user_issues_params
    params.require(:user_issue).permit(:issue_code, :num, :price, :bought_day)
  end

end
