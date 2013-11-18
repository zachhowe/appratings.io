#!/usr/bin/env ruby
require 'bundler'
Bundler.require(:default)

require_relative '../lib/appratings.rb'

require_relative '../app/helpers/data_helper.rb'
require_relative '../app/helpers/app_helper.rb'
require_relative '../app/helpers/rating_helper.rb'
require_relative '../app/helpers/update_helper.rb'

ENV['MONGODB_URI'] = 'mongodb://localhost/appratings' if ENV['MONGODB_URI'].nil?

AppRatings::UpdateHelper.update
