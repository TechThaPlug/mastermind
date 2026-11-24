
require "minitest/autorun"
require_relative "../mastermind"

class MastermindTest < Minitest::Test
  def test_random_code_has_four_valid_colors
    code = Code.new

    assert_equal 4, code.pegs.length
    assert Code.valid?(code.pegs)
  end

  def test_custom_code_is_stored
    code = Code.new(%w[red blue green yellow])

    assert_equal %w[red blue green yellow], code.pegs
  end

  def test_valid_code
    assert Code.valid?(%w[red blue green yellow])
  end

  def test_invalid_code_with_wrong_length
    refute Code.valid?(%w[red blue green])
  end

  def test_invalid_color
    refute Code.valid?(%w[red blue green black])
  end

  def test_exact_matches
    code = Code.new(%w[red blue green yellow])

    result = code.evaluate(%w[red blue green yellow])

    assert_equal({ exact: 4, misplaced: 0 }, result)
  end

  def test_misplaced_matches
    code = Code.new(%w[red blue green yellow])

    result = code.evaluate(%w[blue red yellow green])

    assert_equal({ exact: 0, misplaced: 4 }, result)
  end

  def test_mixed_feedback
    code = Code.new(%w[red blue green yellow])

    result = code.evaluate(%w[red green blue purple])

    assert_equal({ exact: 1, misplaced: 2 }, result)
  end

  def test_duplicate_colors_are_counted_correctly
  code = Code.new(%w[red red blue green])

  result = code.evaluate(%w[red blue blue yellow])

  assert_equal({ exact: 2, misplaced: 0 }, result)
end

  def test_invalid_guess_raises_error
    code = Code.new(%w[red blue green yellow])

    assert_raises(ArgumentError) do
      code.evaluate(%w[red blue black yellow])
    end
  end

  def test_computer_player_starts_with_all_possibilities
    computer = ComputerPlayer.new

    assert_equal 1296, computer.remaining_possibilities
  end

  def test_computer_guess_contains_four_valid_colors
    computer = ComputerPlayer.new
    guess = computer.make_guess

    assert Code.valid?(guess)
  end

  def test_computer_filters_impossible_codes
    computer = ComputerPlayer.new
    guess = %w[red red red red]
    feedback = { exact: 4, misplaced: 0 }

    computer.record_feedback(guess, feedback)

    assert_equal 1, computer.remaining_possibilities
  end
end
