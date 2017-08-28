#[START all]
require "digest/sha2"
require "sinatra"
require "google/cloud/datastore"

get '/' do
  erb :lookup
end

get "/search" do
  project_id = "b-a-k-h"
  datastore = Google::Cloud::Datastore.new
  query     = datastore.query("Product").order("name", :asc).limit(12).
              where("name", ">=", params[:term])
  products  = datastore.run query

  names = Array.new

  products.each do |product|
    names << product['name']
  end

  response.write names

  content_type :json #"text/plain"
  status 200
end

get '/_ah/health' do
  status 200
end

#[END all]
__END__

@@ layout
<html>
  <head>
    <title>awesome lookup app</title>
    <meta charset="utf-8" />
     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="shortcut icon" type="image/png" href="https://storage.googleapis.com/bakh-bucket/favicon.ico"/>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
   </head>
  <body><%= yield %></body>
</html>

@@ lookup
<h1 align="center">awesome lookup app</h1>
<div align="center" class="ui-widget">
  <label for="products">products: </label>
  <input id="products" placeholder="start typing">
</div>
 
<div align="center" class="ui-widget" style="margin-top:2em; font-family:Arial">
  Selection:
  <div id="log" style="height: 200px; width: 300px; overflow: auto;" class="ui-widget-content"></div>
  <div><img src="https://storage.googleapis.com/bakh-bucket/150px-RainbowDashFilly.png" alt="rainbow dash"></div>
</div>

<script>
  $( function() {
    function log( message ) {
      $( "<div>" ).text( message ).prependTo( "#log" );
      $( "#log" ).scrollTop( 0 );
    }
 
    $( "#products" ).autocomplete({
      source: "search",
      minLength: 2,
      select: function( event, ui ) {
        log( "Selected: " + ui.item.value + " aka " + ui.item.id );
      }
    });
  } );

</script>