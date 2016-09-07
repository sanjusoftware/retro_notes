class RetroPanel < ActiveRecord::Base
  belongs_to :retro_board
  validates :name, presence: true

  has_many :retro_cards, :dependent => :destroy

  def add_card card
    card.retro_panel = self
    card.save
  end
end
