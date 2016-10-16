class CreateUserInvestments < ActiveRecord::Migration
  def change
    create_table :user_investments do |t|
      t.integer :user_id
      t.string :investment_code
      t.decimal :price
      t.integer :num
      t.datetime :bought_day

      t.timestamps null: false
    end
  end
end
