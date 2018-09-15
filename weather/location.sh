#Get location
space_location="$(timedatectl status | sed -r -ne 's/\s*Time zone: \w*\/(\w*).*/\1/p')"
location="$(echo $space_location | sed -e 's/_/%20/g')"

#Get the api key
key="$(cat key)"

#Get location key from accuweather
key_url="http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$key&q=$location"

#Query the url
#fetcher="$(curl -X GET $key_url)"

#Get the location number
lkey="$(echo $fetcher | sed -rne 's/[^K]*?Key\":\"(\w*).*/\1/p' )"

#Get all the data from accuweather
info_url="http://dataservice.accuweather.com/currentconditions/v1/$lkey?apikey=$key&details=true"

#Query the url
#json="$(curl -X get $info_url)"
json="$(cat jsontest)"
#echo $json

#Parse the url with python/json
temp="$(echo $json | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['Temperature']['Imperial']['Value'])")"
precip="$(echo $json | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['Precip1hr']['Imperial']['Value'])")"
echo $temp
echo $precip
