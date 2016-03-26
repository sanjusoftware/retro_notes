class RetroBoardsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  before_action :set_retro_board, only: [:show, :update, :destroy, :create_retro_card]

  DEFAULT_RETRO_PANELS = {'What went well?' => '#00a65a', 'What can be done better?' => '#dd4b39', 'Other ideas / suggestions' => '#f39c12'}

  def index
    @projects = current_user.present? ? current_user.projects : []
  end

  def new
    project = nil
    if params[:project].present?
      project = current_user.projects.find_by_id(params[:project])
    end
    if project.blank?
      project = current_user.projects.present? ? current_user.projects.last : Project.find_or_initialize_by(:name => 'Untitled Project')
    end

    @retro_board = RetroBoard.new(:name => 'Untitled Board', :project => project)
    DEFAULT_RETRO_PANELS.each do |panel|
      @retro_board.retro_panels.build(:name => panel[0], :color => panel[1])
    end

    respond_to do |format|
      if @retro_board.save
        format.html { redirect_to retro_board_path(@retro_board)}
        format.json { render action: 'show', status: :created, location: @retro_board }
      else
        format.html { render action: 'show' }
        format.json { render json: @retro_board.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    params_to_update = retro_board_params
    if retro_board_params[:project][:name].present?
      @project = current_user.projects.find_or_create_by(name: retro_board_params[:project][:name])
      params_to_update[:project_id] = @project.id
      params_to_update.delete(:project)
    end

    respond_to do |format|
      if @retro_board.update(params_to_update)
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Retro board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @retro_board.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @retro_board.destroy
    respond_to do |format|
      format.html { redirect_to retro_boards_path, notice: 'Retro board was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def delete_project
    @project = current_user.projects.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to retro_boards_path, notice: 'Project was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retro_board
      @retro_board = RetroBoard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_board_params
      params.require(:retro_board).permit(:name, :project_id, project: [:name], retro_card: [:description])
    end

end
