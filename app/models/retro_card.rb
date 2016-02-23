class RetroCard < ActiveRecord::Base
  belongs_to :retro_panel
  validates :description, presence: true
end
