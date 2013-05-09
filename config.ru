require './app/web'
require './app/admin'

map '/' do
  run AppRatingsWeb
end

map '/admin' do
  run AppRatingsAdmin
end
