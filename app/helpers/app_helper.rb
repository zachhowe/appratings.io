module AppHelper
  def self.add_app(app_id)
    DataHelper.open('apps') do |collection|
      collection.insert({"app_id" => app_id})
    end
  end
  
  def self.list_apps(&block)
    DataHelper.open('apps') do |collection|
      docs = collection.find({}, {:fields => ['app_id', 'info']})

      docs.each do |doc|
        app_id = doc['app_id']
        info = doc['info']
        app_name = info['trackName']

        app = {:app_id => app_id, :app_name => app_name}

        yield app
      end
    end
  end
  
  def self.find_app(app_id)
    doc = nil

    DataHelper.open('apps') do |collection|
      doc = collection.find_one({"app_id" => app_id})
    end
    
    doc
  end
end
