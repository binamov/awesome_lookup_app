# Imports the Google Cloud client library
require "google/cloud/datastore"
require 'json'

# Your Google Cloud Platform project ID
project_id = "b-a-k-h"

# Instantiates a client
datastore = Google::Cloud::Datastore.new

fileinput = File.read('products.json')
products = JSON.parse(fileinput)
products.each do | product |
    entry = datastore.entity 'Product' do |e|
      e['sku'] = product['sku']
      e['name'] = product['name']
      e['type'] = product['type']
      e['price'] = product['price']
      e['upc'] = product['upc']
    end
    datastore.save entry
end
