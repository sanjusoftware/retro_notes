class RetroBoard < ActiveRecord::Base
  belongs_to :project

  attr_accessor :new_project_name
end
