#!/usr/bin/env ruby
# Lambda runtime script

# frozen_string_literal: true


require_relative 'toot'

def lambda_handler(event:, context:)
  runtime
end
