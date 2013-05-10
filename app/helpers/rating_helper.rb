module RatingHelper
  def self.read_ratings(app_id, req_version = nil)
    records = Array.new
    
    DataHelper.open('ratings') do |collection|
      if req_version.nil? || req_version.length == 0
        docs = collection.find({'app_id' => app_id}, {:limit => 10, :sort => [:date, :asc]})
      else
        docs = collection.find({'app_id' => app_id, 'version' => req_version}, {:limit => 10, :sort => [:date, :asc]})
      end

      docs.each do |doc|
        app_name = doc['app_name']
        app_version = doc['version']
        date = doc['date']
        ratings = doc['ratings']

        cur = AppRatings::RatingUtil.weighted_mean(ratings['version'])
        cur_r = (cur * 5)

        # info = {:app_name => app_name, :app_version => app_version}
        records << {:chart_label => "#{date} (#{app_version})", :date => date, :average => cur_r, :version => app_version}
      end
    end

    records
  end
end
