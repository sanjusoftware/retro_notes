class RetroPanelsController < ApplicationController

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

    binding.pry
    respond_to do |format|
      if @retro_panel.save
        format.js
      else
        format.json { render json: @retro_panel.errors, status: :unprocessable_entity }
      end
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
