class RetroBoardsController < ApplicationController
  before_action :set_retro_board, only: [:show, :edit, :update, :destroy]

  DEFAULT_RETRO_PANELS = ['What went wrong?', 'What can be done better?', 'Other ideas / suggestions']

  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @retro_board = RetroBoard.new
    DEFAULT_RETRO_PANELS.each do |panel_name|
      @retro_board.retro_panels.build(:name => panel_name)
    end
  end

  def edit
    if @retro_board.retro_panels.blank?
      DEFAULT_RETRO_PANELS.each do |panel_name|
        @retro_board.retro_panels.build(:name => panel_name)
      end
    end

  end

  def create
    if retro_board_params[:new_project_name].present?
      @project = current_user.projects.create(name: retro_board_params[:new_project_name])
    else
      @project = current_user.projects.find(retro_board_params[:project_id])
    end

    @retro_board = @project.retro_boards.new(retro_board_params)

    respond_to do |format|
      if @retro_board.save
        format.html { redirect_to user_retro_board_path(current_user, @retro_board), notice: 'Retro board was successfully created.' }
        format.json { render action: 'show', status: :created, location: @retro_board }
      else
        format.html { render action: 'new' }
        format.json { render json: @retro_board.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @retro_board.update(retro_board_params)
        format.html { redirect_to user_retro_board_path(current_user, @retro_board), notice: 'Retro board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @retro_board.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @retro_board.destroy
    respond_to do |format|
      format.html { redirect_to user_retro_boards_path(current_user), notice: 'Retro board was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def delete_project
    @project = current_user.projects.find_by_id(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to user_retro_boards_path(current_user), notice: 'Project was successfully deleted.' }
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
      params.require(:retro_board).permit(:name, :new_project_name, :project_id, retro_panels_attributes: [:id, :name])
    end
end
