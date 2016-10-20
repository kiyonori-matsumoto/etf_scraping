class UserSetting < ActiveRecord::Base
  belongs_to :user

  validates :japan_issue,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :japan_bond,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :japan_reit,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :developed_issue,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :developed_bond,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :developed_reit,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :emerging_issue,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :emerging_bond,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :emerging_reit,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true
  validates :commodity,
            numericality:
              { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
            presence: true

  validate :portfolio_total_is_100percent

  def unknown
    0
  end

  private

  def portfolio_total_is_100percent
    if japan_issue + japan_reit + japan_bond + developed_issue +
       developed_reit + developed_bond + emerging_issue + emerging_reit +
       emerging_bond + commodity != 100
      errors[:base] << 'ポートフォリオの合計を１００%にしてください'
    end
  end
end
