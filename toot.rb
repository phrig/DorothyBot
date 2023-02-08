#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require_relative 'get_quotes'
require 'twitter'
require 'httparty'

class String
  def to_b
    case downcase.strip
    when 'true', 'yes', 'on', 't', '1', 'y', '=='
      true
    when 'nil', 'null'
      nil
    else
      false
    end
  end
end

# Mastodon
MASTODON_ENABLED = ENV['MASTODON_ENABLED'].to_b
MASTODON_BASE_URL = ENV['MASTODON_BASE_URL']
MASTODON_ACCESS_TOKEN = ENV['MASTODON_ACCESS_TOKEN']
# Twitter
TWITTER_ENABLED = ENV['TWITTER_ENABLED'].to_b
TWITTER_CONSUMER_KEY        = ENV['TWITTER_CONSUMER_KEY']
TWITTER_CONSUMER_SECRET     = ENV['TWITTER_CONSUMER_SECRET']
TWITTER_ACCESS_TOKEN        = ENV['TWITTER_ACCESS_TOKEN']
TWITTER_ACCESS_TOKEN_SECRET = ENV['TWITTER_ACCESS_TOKEN_SECRET']

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_CONSUMER_KEY
  config.consumer_secret     = TWITTER_CONSUMER_SECRET
  config.access_token        = TWITTER_ACCESS_TOKEN
  config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
end

def get_random_quote(file_path)
  file = File.read(file_path)
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
  "#{combined_quote} :)"
end

def tweet_msg(msg)
  puts 'prepairing to tweet'
  begin
    result = TWITTER_CLIENT.update(msg)
    puts 'tweet complete'
  rescue StandardError => e
    puts "Error tweeting: #{e.message}"
  end
  result
end

def toot_msg(msg)
  puts 'prepairing to toot'
  url = "#{MASTODON_BASE_URL}/api/v1/statuses"
  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{MASTODON_ACCESS_TOKEN}"
  }
  body = { "status": msg }
  res = HTTParty.post(url, headers: headers, body: body.to_json)
  if res.ok?
    puts 'Toot successful'
  else
    puts "Toot unsuccessful #{res.response}"
  end
  res
end

def runtime
  begin
    run_get_quotes
  rescue StandardError => e
    puts "Error generating quotes file: #{e.message}"
  end

  unless File.exist? QUOTES_FILE_PATH
    puts 'No quotes file found, doing nothing'
    return { statusCode: 424, msg: 'No quote file found. Aborting', tweet_id: nil, toot_id: nil, quote: nil }
  end

  puts 'quotes file found, sending messages'
  new_quote = get_random_quote(QUOTES_FILE_PATH)
  puts "our new quote is: #{new_quote}"
  final_result = { quote: new_quote }
  if MASTODON_ENABLED
    toot_result = toot_msg(new_quote)
    final_result[:toot_id] = toot_result['id'].to_s
  end
  if TWITTER_ENABLED
    tweet_result = tweet_msg(new_quote)
    final_result[:tweet_id] = tweet_result['id'].to_s
  end
  final_result[:msg] = 'Success'
  final_result[:statusCode] = 200
  final_result
end

puts runtime if __FILE__ == $PROGRAM_NAME
