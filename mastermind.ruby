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
    @secret_code = Array.new(4)
    (0..3).each do |i|
      @secret_code[i] = random_color
    end
  end

  def play(player)
    current_guess = ''
    until correct_guess?(current_guess) || @turn_number == 12
      @turn_number += 1
      puts "ROUND #{@turn_number}"
      current_guess = player.guess
      display_keypegs(current_guess)
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

  def display_keypegs(guess_array)
    print 'Keypeg Results: '
    puts determine_keypegs(guess_array).shuffle.join(', ') # Result is shuffled to retain info
    puts "\n"
  end

  # This method determines the keypegs to display based on the user's response.
  # Elements are set to nil once they have been processed to avoid repeated counts.
  def determine_keypegs(guess_array)
    keypegs = []
    guess_copy = guess_array
    guess_copy.each_with_index do |color, idx|
      if color == @secret_code[idx] # Correct color and position places Black Keypeg.
        keypegs.push('BK')
        guess_copy[idx] = nil
      elsif guess_copy.include?(color) # Correct color in wrong position places White Keypeg
        keypegs.push('WH')
        guess_copy[idx] = nil
      end
    end
    keypegs
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
    current_guess = []
    while valid_guess?(current_guess) == false
      puts "#{@name}, please enter your guess for the 4 term secret color code separated by spaces: "
      puts "Available Colors: #{CODE_COLORS.join(', ')}"
      print 'YOUR INPUT: '
      current_guess = gets.chomp.upcase.split(' ')
    end
    current_guess
  end

  def valid_guess?(guess)
    guess.all? { |color| CODE_COLORS.include?(color) } && guess.length == 4
  end
end

my_game = Game.new
p my_game.secret_code
player_one = Player.new('Keegan', my_game)

my_game.play(player_one)
