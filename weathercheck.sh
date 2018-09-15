#Get location
if [ -z $1 ]
	then space_location="$(timedatectl status | sed -r -ne 's/\s*Time zone: \w*\/(\w*).*/\1/p')"
else
	space_location=$1
fi
location="$(echo $space_location | sed -e 's/_/%20/g')"

#Get the api key
key="$(cat key)"

#Get location key from accuweather
key_url="http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$key&q=$location"

#Query the url
fetcher="$(curl -sX GET $key_url)"

#Get the location number
lkey="$(echo $fetcher | sed -rne 's/[^K]*?Key\":\"(\w*).*/\1/p' )"

#Get all the data from accuweather
info_url="http://dataservice.accuweather.com/currentconditions/v1/$lkey?apikey=$key&details=true"

#Query the url
json="$(curl -sX GET $info_url)"
#json="$(cat jsontest)" #jsontest is a statif file with the infomation from curling info_url, used to save api calls

#Parse the url with python/json
temp="$(echo $json | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['Temperature']['Imperial']['Value'])")"
precip="$(echo $json | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['Precip1hr']['Imperial']['Value'])")"

#Tell the user if the temperature is greater than 75 degrees and if the precipitation is greater than 0
echo $temp | awk '{if ($1 > 75) print "The temperature is greater than 75 degress"}'
echo $precip | awk '{if ($1 > 0) print "The temperature is greater than 0 degress"}'

