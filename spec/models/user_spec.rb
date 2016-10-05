require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#create" do
    it "generates user_setting on create user" do
      expect { User.create(email: 'a@b.com', password: 'foobar', password_confirmation: 'foobar') }.to change{ UserSetting.count }.by(1)
    end
  end
end
