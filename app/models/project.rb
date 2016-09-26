class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  validates :name, presence: true

  belongs_to :user
  has_many :retro_boards, :dependent => :destroy

  def should_generate_new_friendly_id?
    name_changed?
  end

end
