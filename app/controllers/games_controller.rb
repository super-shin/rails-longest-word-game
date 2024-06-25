require 'open-uri'
require 'json'

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
    @word = params[:entry].upcase
    @picked = session[:pick].dup
    duplicate = @picked.dup
    @word.each_char { |letter| duplicate.delete_at(duplicate.index(letter)) if duplicate.include?(letter) }
    @passed = @word.length == (10 - duplicate.length)
    @data = fetch_word_data(@word)
  end

  def fetch_word_data(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url)
    JSON.parse(response.read)
  end
end
