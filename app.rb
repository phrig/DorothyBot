#!/usr/bin/env ruby
# Lambda runtime script

# frozen_string_literal: true

require 'json'
require 'functions_framework'
require_relative 'toot'

FunctionsFramework.http('runtime') do |_request|
  puts 'STARTING RUNTIME'
  runtime
  puts 'ALL DONE'
  { status: 200 }.to_json
end
