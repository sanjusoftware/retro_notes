class RetroBoard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :project
  has_many :retro_panels, :dependent => :destroy
  validates :name, presence: true

end
