require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score
    @score = ''
    @letters = params[:grid]
    @words = params[:word]
    if included?(@words.upcase, @letters)
      if english_word?
        @score = "Congratulations, #{@words} is a valid english words"
      else
        @score = "Sorry, but #{@words} does not seem to be a valid English word"
      end
    else
      @score = "Sorry, but #{@words} can't be build of #{@letters}"
    end
  end

  def english_word?
    response = open("https://wagon-dictionary.herokuapp.com/#{@words}")
    json = JSON.parse(response.read)
    json['found']
  end
end
