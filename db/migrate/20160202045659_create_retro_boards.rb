class CreateRetroBoards < ActiveRecord::Migration
  def change
    create_table :retro_boards do |t|
      t.string :name
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
