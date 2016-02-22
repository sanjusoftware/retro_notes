class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  validates :name, presence: true

  belongs_to :user
  has_many :retro_boards, :dependent => :destroy

end
