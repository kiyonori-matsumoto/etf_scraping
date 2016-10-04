class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :yearly_deposit

      t.timestamps null: false
    end
  end
end
