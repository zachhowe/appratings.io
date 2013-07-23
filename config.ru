#!/usr/bin/env ruby
require './app/web'
require './app/admin'

if ENV['RACK_ENV'] == 'development'
  ENV['MONGODB_URI'] = 'mongodb://localhost/appratings'
end

if ENV['RACK_ENV'] == 'test'
  ENV['MONGODB_URI'] = 'mongodb://localhost/appratings'
end

map '/' do
  run AppRatingsWeb
end

map '/admin' do
  run AppRatingsAdmin
end
