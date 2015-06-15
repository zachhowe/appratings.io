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
          record_count = collection.count({'app_id' => app_id}) # self.number_of_records_for_app(app_id)

          unless info.nil?
            app_name = info['trackName']

            unless app_name.nil?
              app = {:app_id => app_id, :app_name => app_name, :number_of_records => record_count}

              yield app
            end
          end
        end
      end
    end

    def self.number_of_records_for_app(app_id)
      number_of_records = 0

      DataHelper.open('apps') do |collection|
        number_of_records = collection.count({'app_id' => app_id})
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