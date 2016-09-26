class RetroBoard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :project
  has_many :retro_panels, :dependent => :destroy
  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed?
  end

end
