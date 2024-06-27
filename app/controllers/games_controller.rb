require 'open-uri'
require 'json'

LETTER_POINTS = {
  'A' => 1, 'B' => 3, 'C' => 3, 'D' => 2, 'E' => 1,
  'F' => 4, 'G' => 2, 'H' => 4, 'I' => 1, 'J' => 8,
  'K' => 5, 'L' => 1, 'M' => 3, 'N' => 1, 'O' => 1,
  'P' => 3, 'Q' => 10, 'R' => 1, 'S' => 1, 'T' => 1,
  'U' => 1, 'V' => 4, 'W' => 4, 'X' => 8, 'Y' => 4,
  'Z' => 10
}

class GamesController < ApplicationController
  def new
    @alphabets = ('A'..'Z').to_a
    @pick = []
    10.times do |num|
      random = @alphabets[rand(0..25)]
      @pick << random
    end
    session[:pick] = @pick
  end

  def score
    score_word
    @word = params[:entry].upcase
    @picked = session[:pick].dup
    duplicate = @picked.dup
    @word.each_char { |letter| duplicate.delete_at(duplicate.index(letter)) if duplicate.include?(letter) }
    @passed = @word.length == (10 - duplicate.length)
    @data = fetch_word_data(@word)
    @points = session[:score]
  end

  def fetch_word_data(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url)
    JSON.parse(response.read)
  end

  def score_word
    submitted_word = params[:entry].upcase
    points = calculate_points(submitted_word)

    session[:score] = points
  end

  private

  def calculate_points(word)
    word.chars.sum { |letter| LETTER_POINTS[letter] || 0 }
  end
end
