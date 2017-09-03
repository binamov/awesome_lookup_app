# [START all]
require 'digest/sha2'
require 'sinatra'
require 'google/cloud/datastore'

get '/' do
  erb :lookup
end

get '/search' do
  project_id = 'b-a-k-h'
  datastore = Google::Cloud::Datastore.new
  query     = datastore.query('Product')
                       .select('name')
                       .order('name', :asc)
                       .distinct_on('name')
                       .limit(12)
                       .where('name', '=', params[:term])
  products  = datastore.run query

  names = []

  products.each do |product|
    names << product['name']
  end

  response.write names

  content_type :json
  status 200
end

get '/_ah/health' do
  response.write 'sall good, man'
  status 200
end

# [END all]
__END__
