#!/usr/bin/env ruby
require 'mongo'
require 'appratings'

require_relative '../app/helpers/data_helper.rb'
require_relative '../app/helpers/app_helper.rb'
require_relative '../app/helpers/rating_helper.rb'
require_relative '../app/helpers/update_helper.rb'

UpdateHelper.update
