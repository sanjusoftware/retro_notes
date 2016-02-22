class RetroBoard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :project
  has_many :retro_panels, :dependent => :destroy
  validates :name, presence: true

  accepts_nested_attributes_for :retro_panels, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true

  attr_accessor :new_project_name
end
