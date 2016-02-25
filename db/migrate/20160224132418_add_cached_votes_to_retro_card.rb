class AddCachedVotesToRetroCard < ActiveRecord::Migration
  def self.up
    add_column :retro_cards, :cached_votes_total, :integer, :default => 0
    add_column :retro_cards, :cached_votes_score, :integer, :default => 0
    add_column :retro_cards, :cached_votes_up, :integer, :default => 0
    add_column :retro_cards, :cached_votes_down, :integer, :default => 0
    add_column :retro_cards, :cached_weighted_score, :integer, :default => 0
    add_column :retro_cards, :cached_weighted_total, :integer, :default => 0
    add_column :retro_cards, :cached_weighted_average, :float, :default => 0.0
    add_index  :retro_cards, :cached_votes_total
    add_index  :retro_cards, :cached_votes_score
    add_index  :retro_cards, :cached_votes_up
    add_index  :retro_cards, :cached_votes_down
    add_index  :retro_cards, :cached_weighted_score
    add_index  :retro_cards, :cached_weighted_total
    add_index  :retro_cards, :cached_weighted_average
  end

  def self.down
    remove_column :retro_cards, :cached_votes_total
    remove_column :retro_cards, :cached_votes_score
    remove_column :retro_cards, :cached_votes_up
    remove_column :retro_cards, :cached_votes_down
    remove_column :retro_cards, :cached_weighted_score
    remove_column :retro_cards, :cached_weighted_total
    remove_column :retro_cards, :cached_weighted_average
  end
end
