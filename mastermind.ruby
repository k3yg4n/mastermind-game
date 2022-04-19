class Game
  @@code_colors = %w[RD BU YW GN]
  @@indicator_colors = %w[BK WH]

  attr_accessor :secret_code

  def initialize
    @secret_code = Array.new(6)
    (0..5).each do |i|
      @secret_code[i] = get_random_color
    end
  end

  private
  
  # This method returns one random code color out of the 4 possibilities
  def get_random_color
    @@code_colors.sample
  end

  def display_colors(code_array)
    puts code_array.join("\t")
  end

end


class Player
 def initialize(name)
  @name = name
 end
end

(0..5).each do |i|
  my_game = Game.new()
  p my_game.secret_code
end



