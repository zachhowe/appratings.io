module AppRatings
  class UpdateHelper
    def self.update
      DataHelper.open('apps') do |collection|
        docs = collection.find({}, {:fields => ['app_id']})

        docs.each do |doc|
          app_id = doc['app_id']

          unless app_id.nil?
            puts "Updating info for #{app_id}"
            info = update_app(app_id)

            kind = nil

            unless info.nil?
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

      unless info.nil?
        DataHelper.open('apps') do |collection|
          collection.update(
              {:app_id => app_id},
              {:app_id => app_id, :info => info})
        end
      end

      info
    end

    MAX_TRY_COUNT = 3

    def self.update_ratings(app_id, info)
      0..MAX_TRY_COUNT do |try|
        begin
          ratings = AppRatings::RatingFetcher.fetch_ratings(app_id)
        rescue JSON::ParserError => e
          puts "Try count: #{try} - JSON Parse errer: #{e}"
        rescue Exception => e
          puts "Try count: #{try} - General errer: #{e}"
        end
      end

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
end
