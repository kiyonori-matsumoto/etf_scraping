class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_setting

  def show

  end

  def update
    @setting = current_user.user_setting
    if @setting.update user_setting_params
      # setting.save
      redirect_to user_setting_path
    else
      render :show
    end
  end

  private

  def get_setting
    @setting = current_user.user_setting
  end

  def user_setting_params
    params.require(:user_setting).permit([:yearly_deposit, :japan_issue,
       :japan_reit, :japan_bond, :developed_issue, :developed_reit,
       :developed_bond, :emerging_issue, :emerging_reit, :emerging_bond,
       :commodity])
  end

end
