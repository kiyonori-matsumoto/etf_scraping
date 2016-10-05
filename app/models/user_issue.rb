class UserIssue < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue, primary_key: :issue_code

end
