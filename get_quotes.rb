#! /usr/bin/env ruby
require 'mechanize'
require 'json'

#Build our initial array of all quotes from the web
def build_quote_array
  a = Mechanize.new
  base_url = "https://www.goodreads.com/author/quotes/24956.Dorothy_Parker?page="
  page_count = 8
  all_quotes = []

  for i in 1..page_count do
    page = a.get(base_url + i.to_s)
    page_quotes = page.search('div.quoteText').map {|x| x.text.gsub(/\n/,"").gsub(/Dorothy.*/, "").gsub(/”.*|^.*“/, "")}
    all_quotes = all_quotes + page_quotes
  end
  return all_quotes
end

#Remove all quotes too long for Twitter
def remove_long_quotes(array)
  short_quotes = array.select {|e| e.length <= 140}
end

#build a hash out of the array
def build_hash(array)
  quote_hash = []
  array.each_with_index {|e,i| quote_hash << {id: i + 1, quote: e}}
  return quote_hash
end

#Convert the hash to JSON and write to file
def write_hash_to_file(hash,file_path)
  File.open(file_path, 'w') {|f|
    f.puts hash.to_json
  }
end

#Runtime. Will only run if script called directly and not required
if __FILE__ == $0
  all_quotes = build_quote_array
  tweet_quotes = remove_long_quotes(all_quotes)
  quote_hash = build_hash(tweet_quotes)
  write_hash_to_file(quote_hash, File.expand_path(File.dirname(__FILE__)) + '/quotes.json')
end