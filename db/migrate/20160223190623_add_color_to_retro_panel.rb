class AddColorToRetroPanel < ActiveRecord::Migration
  def change
    add_column :retro_panels, :color, :string
  end
end
