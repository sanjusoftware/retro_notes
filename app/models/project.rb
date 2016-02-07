class Project < ActiveRecord::Base
  belongs_to :user
  has_many :retro_boards
end
