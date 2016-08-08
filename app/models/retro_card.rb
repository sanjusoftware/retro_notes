class RetroCard < ActiveRecord::Base
  acts_as_votable

  has_many :matches
  has_many :matched_retro_cards, through: :matches, dependent: :destroy

  belongs_to :retro_panel
  validates :description, presence: true
end
