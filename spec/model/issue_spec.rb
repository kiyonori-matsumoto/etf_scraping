require 'rails_helper'

RSpec.describe Issue do
  describe 'verification' do
    it 'generates valid factory_girl_rails' do
      issue = build :issue
      expect(issue).to be_valid
    end

    it 'becomes error for wrong company' do
      issue = build(:issue)
      issue.company = 'dummy'
      expect(issue).not_to be_valid
    end
  end
end
