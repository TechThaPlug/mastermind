# Mastermind

A command-line implementation of the classic Mastermind code-breaking game, built with Ruby.

## Features

- Play as the codebreaker against the computer.
- Create a secret code for the computer to guess.
- Six available colors: red, blue, green, yellow, purple, and orange.
- Four-color secret codes.
- Twelve attempts per game.
- Feedback showing correct colors in the correct and incorrect positions.
- Computer guessing strategy that eliminates impossible codes using previous feedback.

## Requirements

- Ruby 4.0.10 or compatible Ruby version.

## Installation

Clone the repository:

```bash
git clone https://github.com/TechThaPlug/mastermind.git
cd mastermind
```

## How to Play

Start the game:

```bash
ruby main.rb
```

Choose one of the available options:

1. Guess the computer's secret code.
2. Create a secret code for the computer to guess.
3. Exit the game.

Enter four colors separated by spaces, using the available colors.

After each guess, you receive two types of feedback:

- **Correct color and position:** The number of colors in the correct positions.
- **Correct color, wrong position:** The number of correct colors in incorrect positions.

You have twelve attempts to crack the code.

## Running Tests

Run the automated test suite:

```bash
ruby -Itest test/mastermind_test.rb
```

## Technologies

- Ruby
- Minitest
- Git and GitHub

## License

This project is licensed under the MIT License.
