class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :daily_id
      t.string :name
      t.string :code
      t.string :url

      t.timestamps null: false
    end
  end
end
