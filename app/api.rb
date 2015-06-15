module AppRatings
  class AppRatingsAPI < Sinatra::Base
    configure :development, :test do
      enable :show_exceptions
    end

    configure :production do
      enable :logging
      disable :dump_errors
      disable :show_exceptions
    end

    get '/list' do
      content_type :json

      apps = Array.new

      AppHelper.list_apps do |app|
        apps << app
      end

      app_list = apps.to_a.sort! do |a, b|
        app1_record_count = b['number_of_records']
        app2_record_count = a['number_of_records']

        if app1_record_count.to_i > app2_record_count.to_i
            return 1
          elsif app1_record_count.to_i < app2_record_count.to_i
            return -1
          end
        end

        return 0
      end

      {:status => 'ok', :results => app_list}.to_json
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

    get '/ratings/daily/:id' do
      content_type :json

      app_id = params[:id]
      version = params[:v]

      app = AppHelper.find_app(app_id)
      raw = RatingHelper.read_ratings_raw(app_id)
      firstDate = raw[:first]
      records = raw[:records]

      app_info = app['info']
      info = {:app_name => app_info['trackName'], :app_version => app_info['version']}

      {:status => 'ok', :results => {:info => info, :first => firstDate, :records => records}}.to_json
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
