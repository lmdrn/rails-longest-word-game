require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    # display a new random grid and a form
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample
    end
  end

  def score
    @word = params[:score]
    @word_array = @word.split('')
    if in_grid
      find_word
    else
      "This #{@word} is not part of the grid!"
    end
  end

  def find_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    valid = open(url).read
    new_word = JSON.parse(valid)
    if new_word['found']
      @score = "Congratulations #{@word.upcase} is a valid English word!"
    else
      @score = "Sorry but #{@word.upcase} does not seem to be a valid English word!"
    end
  end

  def in_grid
    @letters.chars.all? do |letter|
      @letters.upcase.count(letter) >= @word_array.upcase.count(letter)
    end
  end
end
