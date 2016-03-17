class RetroPanelsController < ApplicationController
  include RetroBoardsHelper

  before_action :set_retro_panel, only: [:update, :destroy]

  def update
    respond_to do |format|
      if @retro_panel.update(retro_panel_params)
        format.json { head :no_content }
      else
        format.json { render json: @retro_panel.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @retro_board = RetroBoard.find(params[:retro_board_id])
    @retro_panel = RetroPanel.new(retro_panel_params)
    @retro_panel.retro_board = @retro_board
    @retro_panel.name = 'Untitled Panel' if @retro_panel.name.blank?
    @retro_panel.color = random_color if @retro_panel.color.blank?

    respond_to do |format|
      if @retro_panel.save
        format.js
      else
        format.json { render json: @retro_panel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @retro_board = RetroBoard.find(params[:retro_board_id])
    @retro_panel_id = @retro_panel.id
    @retro_panel.destroy
    respond_to do |format|
      format.html { redirect_to retro_board_path(@retro_board), notice: 'Retro panel was successfully deleted.' }
      format.js { render action: 'remove_retro_panel', status: :ok}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retro_panel
      @retro_panel = RetroPanel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_panel_params
      params.require(:retro_panel).permit(:name, :color, :retro_board_id)
    end

end
