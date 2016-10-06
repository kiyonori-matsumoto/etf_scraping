class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_setting

  def show

  end

  def update
    setting = current_user.user_setting
    setting.yearly_deposit = user_setting_params[:yearly_deposit]
    setting.save
    redirect_to user_setting_path
  end

  private

  def get_setting
    @setting = current_user.user_setting
  end

  def user_setting_params
    params.require(:user_setting).permit([:yearly_deposit])
  end

end
