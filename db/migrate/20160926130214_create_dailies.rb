class CreateDailies < ActiveRecord::Migration
  def change
    create_table :dailies do |t|
      t.decimal :base_price
      t.decimal :issue_price
      t.decimal :total_assets
      t.decimal :total_issued

      t.timestamps null: false
    end
  end
end
