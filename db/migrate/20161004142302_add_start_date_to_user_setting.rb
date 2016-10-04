class AddStartDateToUserSetting < ActiveRecord::Migration
  def change
    add_column :user_settings, :start_date, :datetime
  end
end
