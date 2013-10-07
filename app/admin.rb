module AppRatings
  class AppRatingsAdmin < Sinatra::Base
    configure do
      set :public_folder, File.dirname(__FILE__) + '/../public'
      set :static_cache_control, [:public, :must_revalidate, {:max_age => 300}]
    end

    configure :development, :test do
      enable :show_exceptions
    end

    configure :test, :production do
      enable :logging
      enable :dump_errors

      use Rack::Auth::Basic, "Restricted Area" do |username, password|
        UserHelper.authenticate_user(username, password)
      end
    end

    get '/' do
      cache_control [:public, :must_revalidate, {:max_age => 300}]

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
end
