# frozen_string_literal: true

# This module contains arrays of the colors used in the game
module Colors
  CODE_COLORS = %w[RD BU YW GN].freeze
  INDICATOR_COLORS = %w[BK WH].freeze
end

# This is the class that stores the variables and methods for the game
class Game
  include Colors
  attr_reader :secret_code # TO REMOVE
  attr_accessor :turn_number

  def initialize
    @turn_number = 0
    @secret_code = Array.new(6)
    (0..5).each do |i|
      @secret_code[i] = random_color
    end
  end

  def play(player)
    current_guess = ''
    until correct_guess?(current_guess) || @turn_number == 12
      @turn_number += 1
      current_guess = player.guess
    end
    if correct_guess?(current_guess)
      puts "CONGRATS #{player.name}! You guessed the right code in #{@turn_number} turns!"
    else
      puts "GAMEOVER. #{player.name}, you did not guess the code within 12 turns."
    end
  end

  private

  # This method returns one random code color out of the 4 possibilities
  def random_color
    CODE_COLORS.sample
  end

  def display_colors(code_array)
    puts code_array.join("\t")
  end

  def correct_guess?(guess)
    guess == @secret_code
  end
end

# This class contains the methods and variables for each player
class Player
  include Colors
  attr_reader :name

  def initialize(name, game)
    @name = name
    @game = game
  end

  def guess
    print "#{@name}, please enter your guess for the 6 term secret colour code,"\
          " separated by spaces (Available Colors: #{CODE_COLORS.join(', ')}): "
    gets.chomp.split(' ')
  end
end

my_game = Game.new
p my_game.secret_code
player_one = Player.new('Keegan', my_game)

my_game.play(player_one)
