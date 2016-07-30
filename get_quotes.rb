#! /usr/bin/env ruby
require 'mechanize'
require 'json'

# Get an array of pages with quotes on the page.
def get_pages(count, page_array)
  scraper = Mechanize.new
  base_url = "https://www.goodreads.com/author/quotes/24956.Dorothy_Parker?page=#{count}"
  page = scraper.get(base_url)
  if !page.search('div.quoteText').empty?
    page_array.push(page)
    count += 1
    get_pages(count, page_array)
  else
    puts "Found #{page_array.length} pages of Dorothy Parker quotes."
  end
  return page_array
end

#Build our initial array of all quotes from the web
def build_quote_array(page_array)
  all_quotes = []
  page_array.map do |page|
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
  page_array = get_pages(1, [])
  all_quotes = build_quote_array(page_array)
  tweet_quotes = remove_long_quotes(all_quotes)
  quote_hash = build_hash(tweet_quotes)
  write_hash_to_file(quote_hash, File.expand_path(File.dirname(__FILE__)) + '/quotes.json')
end