class Game < ApplicationRecord
  before_create :check_if_tournament_started

  belongs_to :user
  has_many :participants, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
  validates :rule_match, numericality: true
  validates :rule_goal_difference, numericality: true
  validates :rule_tendency, numericality: true
  validates :rule_miss, numericality: true

  scope :personal, -> { where(private: true) }
  scope :shared, -> { where(private: false) }

  private

  def check_if_tournament_started
    throw(:abort) if Match.all.order(:begins_at).first.begins_at < DateTime.now
  end
end
