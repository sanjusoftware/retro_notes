class RetroCard < ActiveRecord::Base
  acts_as_votable

  belongs_to :retro_panel
  validates :description, presence: true

  def merge(card_to_merge)
    self.description += " | #{card_to_merge.description}"
    card_to_merge.delete
    self.save
  end
end
