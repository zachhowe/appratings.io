module UpdateHelper
  def self.update
    AppHelper.list_apps do |app|
      app_id = app[:app_id]

      puts "Updating info for #{app_id}"
      info = update_app(app_id)

      puts "Updating ratings for #{app_id}"
      ratings = update_ratings(app_id, info)
    end
  end

  private

  def self.update_app(app_id)
    info = AppRatings::RatingFetcher.fetch_info(app_id)

    if !info.nil?
      DataHelper.open('apps') do |collection|
        collection.update(
          {:app_id => app_id},
          {:app_id => app_id, :info => info} )
      end
    end

    info
  end

  def self.update_ratings(app_id, info)
    ratings = AppRatings::RatingFetcher.fetch_ratings(app_id)

    if !ratings[:total].empty? && !ratings[:version].empty?
      DataHelper.open('ratings') do |collection|
        date = Time.now.strftime('%Y-%m-%d')

        collection.remove(
          {:app_id => app_id, :date => date} )

        collection.insert(
          {:app_id => app_id, :version => info['version'], :date => date, :ratings => ratings} )
      end
    end

    ratings
  end
end
