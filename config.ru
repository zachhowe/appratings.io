#!/usr/bin/env ruby
require 'bundler'
Bundler.require(:default, :web)

require './lib/appratings'
require './app/web'
require './app/admin'

require './app/helpers/data_helper.rb'
require './app/helpers/app_helper.rb'
require './app/helpers/rating_helper.rb'
require './app/helpers/user_helper.rb'


if ENV['MONGODB_URI'].nil?
  ENV['MONGODB_URI'] = 'mongodb://localhost/appratings'
end

map '/' do
  run AppRatings::AppRatingsWeb
end

map '/admin' do
  run AppRatings::AppRatingsAdmin
end
