class RetroCardsController < ApplicationController
  skip_before_filter :authenticate_user!

  before_action :set_retro_card, only: [:upvote, :downvote, :update, :destroy]

  def upvote
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      voter = current_or_guest_user
      if !voter.voted_as_when_voted_for @retro_card
        voter.up_votes @retro_card
        format.js { render 'retro_cards/update_votes', status: :ok }
      end

    end
  end

  def downvote
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    respond_to do |format|
      voter = current_or_guest_user
      if voter.voted_as_when_voted_for @retro_card
        voter.down_votes @retro_card
        format.js { render 'retro_cards/update_votes', status: :ok }
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
        format.js { render 'retro_panels/refresh', status: :created }
      else
        format.html { redirect_to retro_board_path(@retro_board), notice: 'Card could not be added.' }
        format.js { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @retro_card.update(retro_card_params)
        @retro_panel = @retro_card.retro_panel
        PrivatePub.publish_to '/retro_card/update', :retro_card => @retro_card
        format.json { head :no_content }
      else
        format.json { render json: @retro_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def merge
    card_to_merge = RetroCard.find(params[:card_to_merge])
    @retro_panel_from = card_to_merge.retro_panel

    if params[:card_to_merge_to].present?
      merge_to_card = RetroCard.find(params[:card_to_merge_to])
      @retro_panel = merge_to_card.retro_panel
      merge_to_card.merge(card_to_merge)
    elsif params[:panel_id].present?
      @retro_panel = RetroPanel.find(params[:panel_id])
      @retro_panel.add_card(card_to_merge)
    end

    respond_to do |format|
      format.json { head :no_content }
      format.js { render 'retro_panels/refresh', status: :created }
    end
  end

  def destroy
    @retro_panel = @retro_card.retro_panel
    @retro_board = @retro_panel.retro_board

    @retro_card.destroy

    respond_to do |format|
      format.js { render 'retro_panels/refresh', status: :ok }
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
