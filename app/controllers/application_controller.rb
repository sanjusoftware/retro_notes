class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_filter :authenticate_user!, :only => [:handle_401_ajax]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (root_path)
  end

  def handle_401_ajax
    respond_to do |f|
      f.js {render partial: 'layouts/handle_401_ajax'}
    end
  end

end
