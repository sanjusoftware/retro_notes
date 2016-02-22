class RetroBoard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :project

  attr_accessor :new_project_name
end
