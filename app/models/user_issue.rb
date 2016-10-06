class UserIssue < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue, primary_key: :code, foreign_key: :issue_code

end
