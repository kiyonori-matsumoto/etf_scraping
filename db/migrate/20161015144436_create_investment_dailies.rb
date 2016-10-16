class CreateInvestmentDailies < ActiveRecord::Migration
  def change
    create_table :investment_dailies do |t|
      t.decimal :base_price
      t.decimal :total_assets
      t.string :investment_code

      t.timestamps null: false
    end
  end
end
