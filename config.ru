#!/usr/bin/env ruby
require 'bundler'
Bundler.require(:default, :web)

require './lib/appratings'
require './app/web'
require './app/api'
require './app/admin'

require './app/helpers/data_helper.rb'
require './app/helpers/app_helper.rb'
require './app/helpers/rating_helper.rb'
require './app/helpers/user_helper.rb'

ENV['MONGODB_URI'] = 'mongodb://localhost/appratings' if ENV['MONGODB_URI'].nil?

map '/' do
  run AppRatings::AppRatingsWeb
end

map '/api' do
  run AppRatings::AppRatingsAPI
end

map '/admin' do
  run AppRatings::AppRatingsAdmin
end
