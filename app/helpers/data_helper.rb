module DataHelper
  def self.open(collection_name, &block)
    client = Mongo::MongoClient.from_uri
    db = client['app15505665']
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
