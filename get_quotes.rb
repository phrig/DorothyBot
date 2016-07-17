#! /usr/bin/env ruby
require 'mechanize'
a = Mechanize.new
page = a.get('https://www.goodreads.com/author/quotes/24956.Dorothy_Parker')
#create array of quotes from first page
quotes2 = page.search('div.quoteText').map {|x| x.text.gsub(/\n/,"").gsub(/Dorothy.*/, "").gsub(/”.*|^.*“/, "")}
#TODO: Loop though each age