require './app/web'
require './app/admin'

# ENV['MONGODB_URI'] = 'mongodb://localhost/super'

map '/' do
  run AppRatingsWeb
end

map '/admin' do
  run AppRatingsAdmin
end
