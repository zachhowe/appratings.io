require './app/web'
require './app/admin'

# ENV['MONGODB_URI'] = 'mongodb://Bx1whnVv0d4Hu3H:192T3X5T9172h8I@alex.mongohq.com:10023/app15505665'

map '/' do
  run AppRatingsWeb
end

map '/admin' do
  run AppRatingsAdmin
end
