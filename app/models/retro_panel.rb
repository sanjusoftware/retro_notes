class RetroPanel < ActiveRecord::Base
  belongs_to :retro_board
  validates :name, presence: true
end
