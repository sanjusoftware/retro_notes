class RetroPanel < ActiveRecord::Base
  belongs_to :retro_board
  validates :name, presence: true

  has_many :retro_cards, :dependent => :destroy

  def direct_cards
    retro_cards - RetroCard.find(Match.all.map(&:matched_retro_card_id))
  end
end
