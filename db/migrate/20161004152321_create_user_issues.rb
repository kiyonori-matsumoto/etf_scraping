class CreateUserIssues < ActiveRecord::Migration
  def change
    create_table :user_issues do |t|
      t.integer :user_id
      t.string :issue_code
      t.decimal :price
      t.integer :num
      t.datetime :bought_day

      t.timestamps null: false
    end
    add_index :user_issues, :issue_code
  end
end
