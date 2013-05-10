require 'sinatra'
require 'mongo'
require 'appratings'
require 'json'
require 'rack'

require_relative 'helpers/data_helper.rb'
require_relative 'helpers/app_helper.rb'
require_relative 'helpers/rating_helper.rb'
require_relative 'helpers/user_helper.rb'

class AppRatingsAdmin < Sinatra::Base
  configure do
    set :public_folder, File.dirname(__FILE__) + '/../public'

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      UserHelper.authenticate_user(username, password)
    end
  end

  configure :development, :test do
    enable :show_exceptions
  end
  
  configure :test, :production do
    enable :logging
    enable :dump_errors
  end

  get '/' do
    send_file File.join(settings.public_folder, 'admin.html')
  end

  get '/env' do
    content_type :json

    ENV.inspect
  end
  
  get '/add/:id' do
    content_type :json

    app_id = params[:id]

    AppHelper.add_app(app_id)
  
    {:status => 'ok'}.to_json
  end
end
