class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if current_user
      @projects = current_user.present? ? current_user.projects : []
      render 'retro_boards/index'
    else
      render 'welcome/index', layout: false
    end
  end
end
