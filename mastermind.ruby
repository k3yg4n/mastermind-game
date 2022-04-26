# frozen_string_literal: true

# Contains arrays of the colors used in the game
module Colors
  CODE_COLORS = %w[RD BU YW GN].freeze
  INDICATOR_COLORS = %w[BK WH].freeze
end

# Contains a function that is used to validate user input
module InputValidation
  include Colors
  def valid_code?(code)
    code.all? { |color| CODE_COLORS.include?(color) } && code.length == 4
  end
end

# Contains functions used to generate randomized 4 term color codes
module RandomCodeCreation
  include Colors
  def random_color
    CODE_COLORS.sample
  end

  def create_random_code
    random_code = []
    (0..3).each do |i|
      random_code[i] = random_color
    end
    random_code
  end
end

# This is the class that stores the variables and methods for the game
class Game
  include Colors
  include InputValidation
  include RandomCodeCreation
  attr_accessor :turn_number

  def initialize(human_player)
    @human_role = human_player.role
    @turn_number = 0
    @secret_code = set_secret_code
  end

  def play(player)
    current_guess = ''
    until correct_guess?(current_guess) || @turn_number == 12
      @turn_number += 1
      puts "ROUND #{@turn_number}"
      current_guess = player.guess
      display_keypegs(current_guess)
    end
    end_game(player.name, current_guess)
  end

  private

  # This method allows the human playing as 'creator' to set the secret code
  def set_secret_code
    return create_random_code unless @human_role == 'creator'

    proposed_code = []
    while valid_code?(proposed_code) == false
      puts 'Please enter your 4 term secret color code separated by spaces. '
      puts "Available Colors: #{CODE_COLORS.join(', ')}"
      print 'Your Code: '
      proposed_code = gets.chomp.upcase.split(' ')
      puts "\n"
    end
    proposed_code
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

  def end_game(name, guess)
    if correct_guess?(guess)
      case @turn_number
      when 1
        puts "CONGRATS #{name}! You guessed the right code in #{@turn_number} turn!"
      else
        puts "CONGRATS #{name}! You guessed the right code in #{@turn_number} turns!"
      end
    else
      puts "GAMEOVER. #{name}, you did not guess the code within 12 turns."
    end
  end
end

# This class contains the methods and variables for each player
class Player
  include Colors
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

# This class contains the methods and variables for the human player
class HumanPlayer < Player
  include Colors
  include InputValidation
  attr_reader :role

  def initialize(name)
    super
    @role = choose_role
  end

  def guess
    current_guess = []
    while valid_code?(current_guess) == false
      puts "#{@name}, please enter your guess for the 4 term secret color code separated by spaces: "
      puts "Available Colors: #{CODE_COLORS.join(', ')}"
      print 'Your Guess: '
      current_guess = gets.chomp.upcase.split(' ')
    end
    current_guess
  end

  private

  def choose_role
    response = ''
    until %w[G C].include?(response)
      print "Enter 'G' if you would like to play as the Guesser or 'C' to play as the creator: "
      response = gets.chomp.upcase
      puts "\n"
    end
    return 'guesser' if response == 'G'

    'creator'
  end
end

# This class contains the methods and variables for the Computer player
class ComputerPlayer < Player
  include Colors
  include InputValidation
  include RandomCodeCreation
  attr_reader :role

  def initialize(name, role)
    super(name)
    @role = role
  end

  def guess
    com_guess = create_random_code
    sleep(2)
    puts "COMPUTER GUESS: #{com_guess.join(' ')}"
    com_guess
  end
end

puts 'Welcome to Mastermind, a code-breaking game between you and a computer.'
puts 'One player is the creator and the other is the guesser.'
puts 'The creator is responsible for generating a 4 term color code consisting of RD(red), BU(blue), YW(yellow),'\
     ' and GN(green).'
puts 'The guesser is given 12 rounds to successfully crack this code, receiving feedback for each of their guesses.'
puts "\n"
print 'Please enter your name to begin: '
human_name = gets.chomp

player_one = HumanPlayer.new(human_name)
com_role = player_one.role == 'guesser' ? 'creator' : 'guesser'
player_two = ComputerPlayer.new('COM', com_role)

my_game = Game.new(player_one)
player_one.role == 'guesser' ? my_game.play(player_one) : my_game.play(player_two)
