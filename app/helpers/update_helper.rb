class UpdateHelper
  def self.update
    DataHelper.open('apps') do |collection|
      docs = collection.find({}, {:fields => ['app_id']})

      docs.each do |doc|
        app_id = doc['app_id']

        if !app_id.nil?
          puts "Updating info for #{app_id}"
          info = update_app(app_id)

          kind = nil
          
          if !info.nil?
            kind = info['kind']
          end

          if !kind.nil? && kind.eql?('software')
            puts "Updating ratings for #{app_id}"
            ratings = update_ratings(app_id, info)
          else
            puts "Skipping ID #{app_id}: Not an App or invalid iTunes Store ID"
          end
        end
      end
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
          {:app_id => app_id,
            :version => info['version'],
            :date => date } )

        collection.insert(
          {:app_id => app_id,
          :version => info['version'],
          :date => date,
          :ratings => ratings,
          :time => Time.now} )
      end
    end

    ratings
  end
end
