require 'httparty'

class GamesController < ApplicationController
  include HTTParty
  base_uri 'https://wagon-dictionary.herokuapp.com'

  VOWELS = %w[A E I O U]
  CONSONANTS = ('A'..'Z').to_a - VOWELS

  def new
    @letters = (CONSONANTS.sample(7) + VOWELS.sample(3)).shuffle
  end

  def score
    @letters = params[:letters].split(' ')
    @word = params[:word].upcase

    if valid_word?(@word) && word_in_grid?(@word, @letters)
      @score = calculate_score(@word, params[:time_taken])
      @message = "Well Done!"
      @api_response = "Word is valid according to the API!"
    else
      @score = 0
      @message = "Invalid word or not in the grid. Try again!"
      @api_response = "Word is invalid or not in the grid according to the API!"
    end
  end

  private

  def valid_word?(word)
    response = self.class.get("/#{word}")
    json_response = JSON.parse(response.body)
    json_response['found']
  end

  def calculate_score(word, time_taken)
    word.length * 10 / time_taken.to_f
  end
end
