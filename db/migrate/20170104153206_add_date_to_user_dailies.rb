class AddDateToUserDailies < ActiveRecord::Migration
  def change
    add_column :user_dailies, :data, :datetime
  end
end
