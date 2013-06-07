class RatingHelper
  def self.read_ratings(app_id, req_version = nil)
    records = Array.new
    
    DataHelper.open('ratings') do |collection|
      if req_version.nil? || req_version.length == 0
        docs = collection.find({'app_id' => app_id}, {:limit => 10, :sort => [:time, :desc]})
      else
        docs = collection.find({'app_id' => app_id, 'version' => req_version}, {:limit => 10, :sort => [:time, :desc]})
      end

      docs.reverse_each do |doc|
        app_name = doc['app_name']
        app_version = doc['version']
        date = doc['date']
        time = doc['time']
        ratings = doc['ratings']

        ratings_total_avg = weighted_mean(ratings['total'])
        ratings_version_avg = weighted_mean(ratings['version'])

        if !time.nil?
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

  def self.weighted_mean(ratings)
    a = Array.new
    ratings.each_pair do |name, val|
      a << [name.to_i, val.to_i]
    end

    mean = a.reduce(0) { |m,r| m += r[0] * r[1] } / a.reduce(0) { |m,r| m += r[1] }.to_f

    mean
  end
end
