#!/bin/bash
 
#Token to authenicate with mindergas.nl
TOKEN=5wWxDZUQ94gSmxm47kh7
 
#fetch meterstand (use jq to parse JSON object correctly)
METERSTAND=`curl -s "http://127.0.0.1:8080/json.htm?type=devices&rid=244"  | jq '.result[0].Counter'| tr -d '"'`
 
#Get OS date, and format it corectly.
NOW=$(date +"%Y-%m-%d")
 
#Build JSON by hand ;-)
JSON='{ "date":"'$NOW'", "reading":"'$METERSTAND'"  }'
 
#post using curl to API
curl -v -H "Content-Type:application/json" -H "AUTH-TOKEN:$TOKEN" -d "$JSON"  https://www.mindergas.nl/api/gas_meter_readings