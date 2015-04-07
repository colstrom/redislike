
require 'bundler/setup'
require 'simplecov'
SimpleCov.command_name 'Kintama'
SimpleCov.start { add_filter '/vendor/' }
require 'redis'
require 'kintama'
require 'moneta'
require 'redislike'

require_relative 'helpers/compatibility'
require_relative 'redislike/lists'
