require 'sinatra'
require 'mongo'
require 'appratings'
require 'json'
require 'rack'

require_relative 'helpers/data_helper.rb'
require_relative 'helpers/app_helper.rb'
require_relative 'helpers/rating_helper.rb'

class AppRatingsAdmin < Sinatra::Base
  configure do
    set :public_folder, File.dirname(__FILE__) + '/../public'
  end

  configure :development, :test do
    enable :show_exceptions
  end
  
  configure :test, :production do
    enable :logging
    enable :dump_errors

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == 'admin' and password == 'Fand4ngo!Rocks'
    end
  end

  get '/' do
    send_file File.join(settings.public_folder, 'admin.html')
  end
  
  get '/add/:id' do
    content_type :json

    app_id = params[:id]

    AppHelper.add_app(app_id)
  
    {:status => 'ok'}.to_json
  end
end
