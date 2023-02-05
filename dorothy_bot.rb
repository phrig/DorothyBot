#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'chatterbot/dsl'
require 'json'

file = File.read('quotes.json')
data_hash = JSON.parse(file)

# get the number of entries
count = data_hash.count
# select random number out of total number of entries
random_number = rand(1...count)
# adjust for array (starts at 0 rather than 1)
random_number -= 1
# store random tweet into variable
chosen_quote = data_hash[random_number]['quote']

# split quote into array of words
split_quote = chosen_quote.split(' ')
# choose two words to capitalize
word1 = rand(1...split_quote.count)
word2 = rand(1...split_quote.count)
split_quote[word1] = split_quote[word1].upcase
split_quote[word2] = split_quote[word2].upcase
combined_quote = split_quote.join(' ')
combined_quote = "#{combined_quote} :)"
# tweet it
# puts combined_quote
tweet combined_quote
