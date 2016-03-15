class RetroBoardsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show, :create_retro_card, :delete_retro_card]

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

  def delete_retro_card
    @retro_card = RetroCard.find_by_id(params[:id])
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    @retro_card.destroy
    respond_to do |format|
      format.js { render action: 'create_retro_card', status: :ok}
      format.json { head :no_content }
    end
  end

  def upvote_retro_card
    @retro_card = RetroCard.find_by_id(params[:id])
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      if current_user.voted_as_when_voted_for @retro_card
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      else
        current_user.up_votes @retro_card
        format.json { head :no_content }
        format.js { render action: 'create_retro_card', status: :ok }
      end

    end
  end

  def downvote_retro_card
    @retro_card = RetroCard.find_by_id(params[:id])
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      if current_user.voted_as_when_voted_for @retro_card
        current_user.down_votes @retro_card
        format.json { head :no_content }
        format.js { render action: 'create_retro_card', status: :ok }
      else
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_retro_card
    @retro_panel = @retro_board.retro_panels.find(params[:retro_panel_id])
    @retro_card = @retro_panel.retro_cards.new(retro_card_params)
    respond_to do |format|
      if @retro_card.save
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Card was successfully added.' }
        format.json { render action: 'show', status: :created, location: @retro_card }
        format.js { render action: 'create_retro_card', status: :created}
      else
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Card could not be added.' }
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_retro_card
    @retro_card = RetroCard.find_by_id(params[:id])

    respond_to do |format|
      if @retro_card.update_attribute(:description, retro_board_params[:retro_card][:description])
        format.json { head :no_content }
      else
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
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
      params.require(:retro_board).permit(:name, :project_id, project: [:name], retro_card: [:description])
    end

    def retro_card_params
      params.require(:retro_card).permit(:description)
    end

end
