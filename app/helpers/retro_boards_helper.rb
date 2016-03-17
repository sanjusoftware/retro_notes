module RetroBoardsHelper
  require 'color-generator'

  def random_color
    '#'+ColorGenerator.new(saturation: 0.3, lightness: 0.30).create_hex
  end
end
