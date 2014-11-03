module AppRatings
  class RatingHelper
    def self.read_available_versions(app_id)
      versions = Set.new

      DataHelper.open('ratings') do |collection|
        docs = collection.find({'app_id' => app_id}, {:fields => [:version], :sort => [:version, :desc]})

        docs.reverse_each do |doc|
          versions << doc['version']
        end
      end

      versions.to_a.sort! { |a, b|
        compare_versions(a, b)
      }
    end

    def self.read_ratings(app_id, version = nil, limit = 10)
      records = Array.new

      DataHelper.open('ratings') do |collection|
        if version.nil? || version.length == 0
          docs = collection.find({'app_id' => app_id}, {:limit => limit, :sort => [:time, :desc]})
        else
          docs = collection.find({'app_id' => app_id, 'version' => version}, {:limit => limit, :sort => [:time, :desc]})
        end

        items = docs.to_a.sort! { |a, b|
          compare_versions(b['version'], a['version'])
        }

        items.reverse_each do |doc|
          #app_name = doc['app_name']
          app_version = doc['version']
          date = doc['date']
          time = doc['time']
          ratings = doc['ratings']

          ratings_total_avg = RatingUtil.weighted_mean(ratings['total'])
          ratings_version_avg = RatingUtil.weighted_mean(ratings['version'])

          unless time.nil?
            date = time.strftime('%Y-%m-%d')
          end

          records << {
            :chart_label => "#{date} (#{app_version})",
            :date => date,
            # :time => time,
            :average => ratings_version_avg,
            :ratings_total_avg => ratings_total_avg,
            :ratings_version_avg => ratings_version_avg,
            :version => app_version
          }
        end
      end

      records
    end

    private

    def self.compare_versions(v1, v2)
      v1s = v1.split('.')
      v2s = v2.split('.')

      max = v1s.count > v2s.count ? v1s.count : v2s.count

      max.times do |i|
        v1i = i < v1s.count ? v1s[i] : '0'
        v2i = i < v2s.count ? v2s[i] : '0'

        if (v1i.to_i > v2i.to_i)
          return 1
        elsif (v1i.to_i < v2i.to_i)
          return -1
        end
      end

      return 0
    end
  end
end
