class RetroBoardsController < ApplicationController
  before_action :set_retro_board, only: [:show, :edit, :update, :destroy, :create_new_card]

  DEFAULT_RETRO_PANELS = {'What went well?' => '#00a65a', 'What can be done better?' => '#dd4b39', 'Other ideas / suggestions' => '#f39c12'}

  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @retro_board = RetroBoard.new
    DEFAULT_RETRO_PANELS.each do |panel|
      @retro_board.retro_panels.build(:name => panel[0], :color => panel[1])
    end
  end

  def edit
    if @retro_board.retro_panels.blank?
      DEFAULT_RETRO_PANELS.each do |panel|
        @retro_board.retro_panels.build(:name => panel[0], :color => panel[1])
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

  def delete_retro_card
    @retro_card = RetroCard.find_by_id(params[:id])
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    @retro_card.destroy
    respond_to do |format|
      format.js { render action: 'create_new_card', status: :ok}
      format.json { head :no_content }
    end
  end

  def create_new_card
    @retro_panel = @retro_board.retro_panels.find(params[:retro_panel_id])
    @retro_card = @retro_panel.retro_cards.new(retro_card_params)
    respond_to do |format|
      if @retro_card.save
        format.html { redirect_to user_retro_board_path(current_user, @retro_board), notice: 'Card was successfully added.' }
        format.json { render action: 'show', status: :created, location: @retro_card }
        format.js { render action: 'create_new_card', status: :created}
      else
        format.html { redirect_to user_retro_board_path(current_user, @retro_board), notice: 'Card could not be added.' }
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retro_board
      @retro_board = RetroBoard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_board_params
      params.require(:retro_board).permit(:name, :new_project_name, :project_id, retro_panels_attributes: [:id, :name, :color], retro_card: [:description => :string])
    end

    def retro_card_params
      params.require(:retro_card).permit(:description)
    end

end
