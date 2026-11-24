
class Code
  COLORS = %w[red blue green yellow purple orange].freeze
  LENGTH = 4

  attr_reader :pegs

  def initialize(pegs = nil)
    @pegs = pegs || generate_random_code
    validate_code!
  end

  def self.valid?(pegs)
    pegs.is_a?(Array) &&
      pegs.length == LENGTH &&
      pegs.all? { |color| COLORS.include?(color.to_s.downcase) }
  end

  def evaluate(guess)
    raise ArgumentError, "Invalid guess." unless self.class.valid?(guess)

    normalized_guess = guess.map { |color| color.to_s.downcase }

    exact = @pegs.zip(normalized_guess).count do |secret, guessed|
      secret == guessed
    end

    remaining_secret = []
    remaining_guess = []

    @pegs.zip(normalized_guess).each do |secret, guessed|
      next if secret == guessed

      remaining_secret << secret
      remaining_guess << guessed
    end

    misplaced = (remaining_secret & remaining_guess).sum do |color|
      [remaining_secret.count(color), remaining_guess.count(color)].min
    end

    {
      exact: exact,
      misplaced: misplaced
    }
  end

  private

  def generate_random_code
    Array.new(LENGTH) { COLORS.sample }
  end

  def validate_code!
    return if self.class.valid?(@pegs)

    raise ArgumentError,
          "Code must contain exactly #{LENGTH} valid colors."
  end
end


class ComputerPlayer
  def initialize
    @possible_codes = Code::COLORS.repeated_permutation(Code::LENGTH).to_a
    @history = []
  end

  def make_guess
    @possible_codes.sample
  end

  def record_feedback(guess, feedback)
    @history << [guess, feedback]

    @possible_codes.select! do |candidate|
      secret = Code.new(candidate)

      @history.all? do |previous_guess, previous_feedback|
        secret.evaluate(previous_guess) == previous_feedback
      end
    end
  end

  def remaining_possibilities
    @possible_codes.length
  end
end

class Game
  MAX_TURNS = 12

  def initialize(mode)
    @mode = mode
    @turns = 0
    @computer = ComputerPlayer.new
  end

  def play
    if @mode == :human_guesses
      human_guesses
    elsif @mode == :computer_guesses
      computer_guesses
    else
      raise ArgumentError, "Invalid game mode."
    end
  end

  private

  def human_guesses
    secret = Code.new

    puts "\nThe computer has created a secret code."
    puts "Available colors: #{Code::COLORS.join(', ')}"
    puts "You have #{MAX_TURNS} attempts to crack it."

    while @turns < MAX_TURNS
      guess = get_human_guess
      @turns += 1

      feedback = secret.evaluate(guess)
      display_feedback(feedback)

      if feedback[:exact] == Code::LENGTH
        puts "\nCongratulations! You cracked the code!"
        return
      end

      puts "Attempts remaining: #{MAX_TURNS - @turns}"
    end

    puts "\nGame over! The secret code was: #{secret.pegs.join(', ')}"
  end

  def computer_guesses
    puts "\nCreate a secret code for the computer to guess."
    puts "Available colors: #{Code::COLORS.join(', ')}"

    secret = Code.new(get_secret_code)

    puts "\nThe computer will now try to crack your code!"

    while @turns < MAX_TURNS
      guess = @computer.make_guess
      @turns += 1

      feedback = secret.evaluate(guess)

      puts "\nComputer guess #{@turns}: #{guess.join(', ')}"
      display_feedback(feedback)

      if feedback[:exact] == Code::LENGTH
        puts "\nThe computer cracked your code!"
        return
      end

      @computer.record_feedback(guess, feedback)
      puts "Possible codes remaining: #{@computer.remaining_possibilities}"
    end

    puts "\nThe computer couldn't crack your code!"
    puts "Your secret code was: #{secret.pegs.join(', ')}"
  end

  def get_human_guess
    loop do
      print "\nEnter four colors separated by spaces: "
      guess = gets&.strip&.downcase&.split

      return guess if Code.valid?(guess)

      puts "Invalid guess. Choose four valid colors."
    end
  end

  def get_secret_code
    loop do
      print "\nEnter your secret code (four colors): "
      code = gets&.strip&.downcase&.split

      return code if Code.valid?(code)

      puts "Invalid code. Choose four valid colors."
    end
  end

  def display_feedback(feedback)
    puts "Correct color and position: #{feedback[:exact]}"
    puts "Correct color, wrong position: #{feedback[:misplaced]}"
  end
end
