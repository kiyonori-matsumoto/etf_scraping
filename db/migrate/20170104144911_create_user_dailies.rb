class CreateUserDailies < ActiveRecord::Migration
  def change
    create_table :user_dailies do |t|
      t.decimal :total
      t.decimal :paid

      t.timestamps null: false
    end
  end
end
