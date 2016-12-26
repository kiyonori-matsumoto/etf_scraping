class UserInvestmentsController < ApplicationController

  before_action :authenticate_user!

  def index
    @user_investments = current_user.user_investments
  end

  def new
    @user_investment = UserInvestment.new investment_code: params[:code], price: params[:price], num: params[:num]
  end

  def create
    user_investment = current_user.user_investments.new(user_investment_params)
    user_investment.bought_day = Date.today

    if user_investment.save
      redirect_to user_issues_path
    else
      flash[:danger] = "failed to create"
      @user_investment = UserInvestment.new investment_code: params[:code], price: params[:price], num: params[:num]
      render 'new'
    end
  end


  private

  def user_investment_params
    params.require(:user_investment).permit([:investment_code, :num, :price])
  end
end
