class CreateRetroCards < ActiveRecord::Migration
  def change
    create_table :retro_cards do |t|
      t.text :description
      t.integer :retro_panel_id

      t.timestamps null: false
    end
  end
end
