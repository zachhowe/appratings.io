#!/usr/bin/env ruby
require 'mongo'

require_relative '../app/helpers/data_helper.rb'
require_relative '../app/helpers/user_helper.rb'

if ARGV.count > 0
	cmd = ARGV.shift
  arg_count = ARGV.count

  if cmd.eql?('add') && arg_count == 2
    username = ARGV[0]
    password = ARGV[1]

    puts "Attempting to add user #{username} : #{password}"

    result = UserHelper.add_user(username, password)

    status = result ? 'created' : 'already exists'

    puts "User '#{username}' #{status}."
  elsif cmd.eql?('delete') && arg_count == 1
    username = ARGV[0]

    puts "Attempting to remove user #{username}"

    result = UserHelper.remove_user(username)

    status = result ? 'deleted' : 'does not exist'

    puts "User '#{username}' #{status}."
  end
else
  puts 'Nothing to do.'
end
