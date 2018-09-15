#Get location
space_location="$(timedatectl status | sed -r -ne 's/\s*Time zone: \w*\/(\w*).*/\1/p')"
location="$(echo $space_location | sed -e 's/_/%20/g')"

#Get the api key
key="$(cat key)"

#Get location key from accuweather
url="http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$key&q=$location"

#Query the url
JSON="$(curl -X GET $url)"

#Get the location number
lkey="$(echo $JSON | sed -rne 's/[^K]*?Key\":\"(\w*).*/\1/p' )"
