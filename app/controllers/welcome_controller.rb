class WelcomeController < ApplicationController
  def index
    @project = current_user.projects.last
    @retro_board = @project.retro_boards.last if @project
  end
end
