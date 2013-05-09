#!/usr/bin/env ruby
require 'mongo'
require 'appratings'

require_relative '../app/helpers/data_helper.rb'
require_relative '../app/helpers/app_helper.rb'
require_relative '../app/helpers/rating_helper.rb'
require_relative '../app/helpers/update_helper.rb'

# ENV['MONGODB_URI'] = 'mongodb://Bx1whnVv0d4Hu3H:192T3X5T9172h8I@alex.mongohq.com:10023/app15505665'

UpdateHelper.update
