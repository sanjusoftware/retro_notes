class RetroBoardsController < ApplicationController
  before_action :set_retro_board, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @retro_board = RetroBoard.new
  end

  def edit
  end

  def create
    if retro_board_params[:new_project_name].present?
      @project = current_user.projects.create(name: retro_board_params[:new_project_name])
    else
      @project = current_user.projects.find(retro_board_params[:project])
    end

    @retro_board = @project.retro_boards.new(name: retro_board_params[:name])

    respond_to do |format|
      if @retro_board.save
        format.html { redirect_to user_retro_boards_path(@retro_board), notice: 'Retro board was successfully created.' }
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
        format.html { redirect_to @retro_board, notice: 'Retro board was successfully updated.' }
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
      format.html { redirect_to retro_boards_url }
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
      params.require(:retro_board).permit(:name, :new_project_name, :project)
    end
end
