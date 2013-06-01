module DataHelper
  def self.database_name_from_uri(uri)
    begin
      u = URI(uri)
      u.path[1..-1]
    rescue ArgumentError
    end
  end

  def self.open(collection_name, &block)
    db_name = database_name_from_uri(ENV['MONGODB_URI'])

    client = Mongo::MongoClient.from_uri
    db = client[db_name]
    collection = db[collection_name]
  
  	case block.arity
  		when 0
  			yield
  		when 1
  			yield collection
  	end
  
    client.close
  end
end
