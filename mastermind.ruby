# frozen_string_literal: true

# This module contains arrays of the colors used in the game
module Colors
  CODE_COLORS = %w[RD BU YW GN].freeze
  INDICATOR_COLORS = %w[BK WH].freeze
end

# This is the class that stores the variables and methods for the game
class Game
  include Colors
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
    end_game(player)
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
    guess_copy = guess_array.dup
    secret_copy = @secret_code.dup
    puts 'Keypeg Results:'
    puts "BK (Correct color in the correct location): #{get_black_keypegs(guess_copy, secret_copy)}"
    puts "WH (Correct color in the wrong location): #{get_white_keypegs(guess_copy, secret_copy)}"
    puts "\n"
  end

  # Returns the number of black keypegs and nils processed terms in secret_copy
  def get_black_keypegs(guess_copy, secret_copy)
    num_bk_keypegs = 0
    guess_copy.each_with_index do |color, idx|
      next unless color.nil? == false && color == secret_copy[idx]

      num_bk_keypegs += 1
      guess_copy[idx] = nil
      secret_copy[idx] = nil
    end
    num_bk_keypegs
  end

  def get_white_keypegs(guess_copy, secret_copy)
    num_wh_keypegs = 0
    guess_copy.each_with_index do |color, idx|
      next unless color.nil? == false && secret_copy.include?(color)

      idx_to_nil = secret_copy.find_index(color)
      secret_copy[idx_to_nil] = nil
      guess_copy[idx] = nil
      num_wh_keypegs += 1
    end
    num_wh_keypegs
  end

  def end_game(player)
    case @turn_number
    when 12
      puts "GAMEOVER. #{player.name}, you did not guess the code within 12 turns."
    when 1
      puts "CONGRATS #{player.name}! You guessed the right code in #{@turn_number} turn!"
    else
      puts "CONGRATS #{player.name}! You guessed the right code in #{@turn_number} turns!"
    end
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
      print 'Your Guess: '
      current_guess = gets.chomp.upcase.split(' ')
    end
    current_guess
  end

  def valid_guess?(guess)
    guess.all? { |color| CODE_COLORS.include?(color) } && guess.length == 4
  end
end

my_game = Game.new
player_one = Player.new('Keegan', my_game)

my_game.play(player_one)
