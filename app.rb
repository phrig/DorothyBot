# frozen_string_literal: true

require 'json'
require_relative 'toot'

def lambda_handler(event:, context:)
  runtime
  # TODO: implement
  { statusCode: 200, body: JSON.generate(ENV['FOO']) }
end
