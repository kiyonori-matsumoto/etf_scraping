class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :user_setting, dependent: :destroy
  has_many :user_issues, dependent: :destroy
  has_many :user_investments, dependent: :destroy

  after_create :create_new_setting

  private

  def create_new_setting
    puts "***createing user setting****"
    us = build_user_setting(yearly_deposit: 0, start_date: Time.now, japan_issue: 0, commodity: 100)
    us.save
  end
end
