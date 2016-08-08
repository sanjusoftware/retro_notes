class Match < ActiveRecord::Base

  belongs_to :retro_card
  belongs_to :matched_retro_card, class_name: 'RetroCard'

  # after_create :create_inverse, unless: :has_inverse?
  # after_destroy :destroy_inverses, if: :has_inverse?
  #
  # def create_inverse
  #   self.class.create(inverse_match_options)
  # end
  #
  # def destroy_inverses
  #   inverses.destroy_all
  # end
  #
  # def has_inverse?
  #   self.class.exists?(inverse_match_options)
  # end
  #
  # def inverses
  #   self.class.where(inverse_match_options)
  # end
  #
  # def inverse_match_options
  #   { matched_retro_card_id: retro_card_id, retro_card_id: matched_retro_card_id }
  # end

end
