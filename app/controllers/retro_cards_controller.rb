class RetroCardsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create, :destroy]

  before_action :set_retro_card, only: [:upvote, :downvote, :update, :destroy]

  def upvote
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      if current_user.voted_as_when_voted_for @retro_card
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      else
        current_user.up_votes @retro_card
        format.json { head :no_content }
        format.js { render 'retro_panels/refresh', status: :ok }
      end

    end
  end

  def downvote
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      if current_user.voted_as_when_voted_for @retro_card
        current_user.down_votes @retro_card
        format.json { head :no_content }
        format.js { render 'retro_panels/refresh', status: :ok }
      else
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @retro_board = RetroBoard.find(params[:retro_board_id])
    @retro_panel = RetroPanel.find(params[:retro_panel_id])
    @retro_card = @retro_panel.retro_cards.new(retro_card_params)
    respond_to do |format|
      if @retro_card.save
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Card was successfully added.' }
        format.json { render action: 'show', status: :created, location: @retro_card }
        format.js { render 'retro_panels/refresh', status: :created}
      else
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Card could not be added.' }
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @retro_card.update(retro_card_params)
        @retro_panel = @retro_card.retro_panel
        format.json { head :no_content }
        format.js { render 'retro_panels/refresh', status: :created}
      else
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    @retro_card.destroy
    respond_to do |format|
      format.js { render 'retro_panels/refresh', status: :ok}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retro_card
      @retro_card = RetroCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_card_params
      params.require(:retro_card).permit(:description, :retro_panel_id)
    end

end
