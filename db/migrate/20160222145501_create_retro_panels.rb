class CreateRetroPanels < ActiveRecord::Migration
  def change
    create_table :retro_panels do |t|
      t.string :name
      t.integer :retro_board_id

      t.timestamps null: false
    end
  end
end
