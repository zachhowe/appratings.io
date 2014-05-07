#!/usr/bin/env ruby
require 'bundler'
Bundler.require(:default, :tools)

include AppRatings

require_relative '../app/helpers/data_helper.rb'
require_relative '../app/helpers/user_helper.rb'

ENV['MONGODB_URI'] = 'mongodb://localhost/appratings' if ENV['MONGODB_URI'].nil?

COMMANDS = %w(add remove change-password)

global_opts = Trollop::options do
  version '0.1'
  banner "AppRatings User Admin Tool #{version} (c) 2013 Zachary Howe"

  opt :debug, 'Debug command parsing logic', :short => '-d'

  stop_on COMMANDS
end

cmd = ARGV.shift # get the command

cmd_opts = case cmd
             when 'add'
               Trollop::options do
                 opt :username, 'Username to add', :short => '-u', :type => :string
                 opt :password, 'Password to use for new user', :short => '-p', :type => :string
               end
             when 'remove'
               Trollop::options do
                 opt :username, 'Username to remove', :short => '-u', :type => :string
           end
             when 'change-password'
               Trollop::options do
                 opt :username, 'Username to change password of', :short => '-u', :type => :string
                 opt :password, 'New password for username', :short => '-p', :type => :string
               end
             when nil
               Trollop::die 'Nothing to do.'
             else
               Trollop::die "Unknown subcommand #{cmd.inspect}"
           end

if global_opts[:debug]
  puts "Global options: #{global_opts.inspect}"
  puts "Subcommand: #{cmd.inspect}"
  puts "Subcommand options: #{cmd_opts.inspect}"
  puts "Remaining arguments: #{ARGV.inspect}"
end

if cmd.eql?('add')
  Trollop::die :username, 'must be specified' unless cmd_opts[:username_given]
  Trollop::die :password, 'must be specified' unless cmd_opts[:password_given]

  username = cmd_opts[:username]
  password = cmd_opts[:password]

  puts "Attempting to add user '#{username}' with password: '#{password}'"

  unless UserHelper.user_exists?(username)
    status = 'added' if UserHelper.add_user(username, password)
  else
    status = 'already exists'
  end

  puts "User '#{username}' #{status}."
elsif cmd.eql?('remove')
  Trollop::die :username, 'must be specified' unless cmd_opts[:username_given]

  username = cmd_opts[:username]

  puts "Attempting to remove user '#{username}'"

  result = UserHelper.remove_user(username)

  status = result ? 'deleted' : 'does not exist'

  puts "User '#{username}' #{status}."
elsif cmd.eql?('change-password')
  Trollop::die :username, 'must be specified' unless cmd_opts[:username_given]
  Trollop::die :password, 'must be specified' unless cmd_opts[:password_given]

  puts 'User password change not implemented'
end
