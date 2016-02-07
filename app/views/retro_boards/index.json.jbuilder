json.array!(@retro_boards) do |retro_board|
  json.extract! retro_board, :id, :name, :project_id
  json.url retro_board_url(retro_board, format: :json)
end
