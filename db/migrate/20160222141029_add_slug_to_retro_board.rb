class AddSlugToRetroBoard < ActiveRecord::Migration
  def change
    add_column :retro_boards, :slug, :string
    add_index :retro_boards, :slug, unique: true
  end
end
