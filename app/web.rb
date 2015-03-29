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
  end
end
