
require_relative "mastermind"

def display_menu
  puts "\n================================"
  puts "       MASTERMIND GAME"
  puts "================================"
  puts "1. Guess the computer's code"
  puts "2. Create a code for the computer"
  puts "3. Exit"
  puts "================================"
end

loop do
  display_menu
  print "Choose an option: "

  choice = gets&.strip

  case choice
  when "1"
    Game.new(:human_guesses).play
  when "2"
    Game.new(:computer_guesses).play
  when "3"
    puts "\nThanks for playing Mastermind!"
    break
  else
    puts "\nInvalid choice. Please select 1, 2, or 3."
  end
end
