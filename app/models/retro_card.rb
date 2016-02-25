class RetroCard < ActiveRecord::Base
  acts_as_votable

  belongs_to :retro_panel
  validates :description, presence: true
end
