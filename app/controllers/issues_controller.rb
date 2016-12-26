class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.order(code: :asc)
    @today_budget = 0
    if(user_signed_in?)
      @yearly_deposit_with_start = current_user.user_setting.yearly_deposit
        if current_user.user_setting.start_date.year == Date.today.year
          @yearly_deposit_with_start *= (1 - current_user.user_setting.start_date.yday / Date.today.end_of_year.yday.to_f )
        end
      @chart = current_user.user_issues
        .where(bought_day: [Date.today.beginning_of_year..Date.today])
        .order(bought_day: :asc)
        .inject(Hash.new(0)) {|a, e| a[e[:bought_day].to_date] += e[:price] * e[:num]; a}
      @chart += current_user.user_investments
        .where(bought_day: [Date.today.beginning_of_year..Date.today])
        .order(bought_day: :asc)
        .inject(Hash.new(0)) {|a, e| a[e[:bought_day].to_date] += e[:price]; a}
      @user_stacked = @chart.reduce(0){|a, e| a += e[1]}
      @user_should_stacked = current_user.user_setting.yearly_deposit * (Date.today.yday / Date.today.end_of_year.yday.to_f) - (current_user.user_setting.yearly_deposit - @yearly_deposit_with_start)

      @today_budget = @user_should_stacked - @user_stacked

      @user_stocks = current_user.user_issues.group(:issue_code).sum(:num)
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @dailies = @issue.dailies.order(created_at: :desc).take(20)
    @chart = @issue.dailies.group_by_day(:created_at, 'max', 'end_price')
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def issue_params
    params.require(:issue)
          .permit(:name, :code, :url, :company, :base_unit, :trade_unit)
  end
end
