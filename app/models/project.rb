class Project < ActiveRecord::Base
  belongs_to :user
  has_many :retro_boards, :dependent => :destroy
end
