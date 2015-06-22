module AppRatings
  class AppHelper
    def self.add_app(app_id)
      DataHelper.open('apps') do |collection|
        collection.insert({'app_id' => app_id})
      end
    end

    def self.remove_app(app_id)
      DataHelper.open('apps') do |collection|
        collection.delete({'app_id' => app_id})
      end
    end

    def self.list_apps(&block)
      DataHelper.open('apps') do |collection|
        docs = collection.find({}, {:fields => ['app_id', 'info']})

        docs.each do |doc|
          app_id = doc['app_id']
          info = doc['info']
          record_count = number_of_records_for_app(app_id)

          unless info.nil? || record_count.eql?(0)
            app_name = info['trackName']

            unless app_name.nil?
              app = {:app_id => app_id, :app_name => app_name, :number_of_records => record_count}

              yield app
            end
          end
        end
      end
    end

    def self.sort_app_list_by_number_of_records(apps)
      app_list = apps.to_a.sort! do |a, b|
        a[:number_of_records] <=> b[:number_of_records]
      end

      app_list
    end

    def self.number_of_records_for_app(app_id)
      number_of_records = 0

      DataHelper.open('ratings') do |collection|
        number_of_records = collection.find({:app_id => app_id}).count
      end

      number_of_records
    end

    def self.find_app(app_id)
      doc = nil

      DataHelper.open('apps') do |collection|
        doc = collection.find_one({'app_id' => app_id})
      end

      doc
    end
  end
end