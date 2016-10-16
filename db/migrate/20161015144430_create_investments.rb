class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.string :name
      t.string :code
      t.string :portfolio_type
      t.string :url

      t.timestamps null: false
    end
  end
end
