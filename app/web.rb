module AppRatings
  class AppRatingsWeb < Sinatra::Base
    configure do
      set :public_folder, File.dirname(__FILE__) + '/../public'
    end

    configure :development, :test do
      enable :show_exceptions
    end

    configure :production do
      enable :logging
      disable :dump_errors
      disable :show_exceptions
    end

    get '/' do
      cache_control [:public, :must_revalidate, {:max_age => 300}]

      send_file File.join(settings.public_folder, 'index.html')
    end

    get '/list' do
      content_type :json

      apps = Array.new

      AppHelper.list_apps do |app|
        apps << app
      end

      {:status => 'ok', :results => apps}.to_json
    end

    get '/info/:id' do
      content_type :json

      app_id = params[:id]

      app = AppHelper.find_app(app_id)

      {:status => 'ok', :results => app['info']}.to_json
    end

    get '/versions/:id' do
      content_type :json

      app_id = params[:id]

      versions = RatingHelper.read_available_versions(app_id)

      {:status => 'ok', :results => versions}.to_json
    end

    get '/ratings/:id' do
      content_type :json

      app_id = params[:id]
      version = params[:v]

      app = AppHelper.find_app(app_id)
      records = RatingHelper.read_ratings(app_id)

      app_info = app['info']
      info = {:app_name => app_info['trackName'], :app_version => app_info['version']}

      {:status => 'ok', :results => {:info => info, :records => records}}.to_json
    end

    get '/ratings/:id/by-versions/:versions' do
      content_type :json

      app_id = params[:id]
      versions = params[:versions].split(',')

      app = AppHelper.find_app(app_id)
      records = []
      versions.each do |version|
        record = RatingHelper.read_ratings(app_id, version, 1)
        records << record[0]
      end

      app_info = app['info']
      info = {:app_name => app_info['trackName'], :app_version => app_info['version']}

      {:status => 'ok', :results => {:info => info, :records => records}}.to_json
    end
  end
end
