class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :user
  has_many :retro_boards, :dependent => :destroy

end
