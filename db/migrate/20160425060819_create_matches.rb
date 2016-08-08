class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :retro_card, index: true, foreign_key: true
      t.references :matched_retro_card, index: true

      t.timestamps null: false

    end

    add_foreign_key :matches, :retro_cards, column: :matched_retro_card_id
    add_index :matches, [:retro_card_id, :matched_retro_card_id], unique: true

  end
end
