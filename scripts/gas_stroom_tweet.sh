#!/bin/bash				

timestamp=`/bin/date +%H`

gasvandaag=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=5122"`
echo $gasvandaag > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
gasvandaag=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $33, $34}' | awk '{print $3}' | sed 's/\"//g'`

opgewektvandaag=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=15"`
echo $opgewektvandaag= > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
opgewektvandaag=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $33, $34}' | awk -F ', "' '{print $1}' | sed 's/"//g'`

opgewekttotaal=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=15"`
echo $opgewekttotaal > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
opgewekttotaal=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $34, $35}' | awk '{print $3}' | sed 's/\"//g'`

verbruikvandaag=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=16"`
echo $verbruikvandaag > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
verbruikvandaag=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $32, $33}' | awk '{print $3}' | sed 's/\"//g'`

verbruiktotaal=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=16"`
echo $verbruiktotaal > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
verbruiktotaal=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $34, $35}' | awk '{print $3}' | sed 's/\"//g'`

afgenomenvandaag=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=5118"`
echo $afgenomenvandaag > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
afgenomenvandaag=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $36, $37}' | awk -F ', "' '{print $1}' | sed 's/"//g'`

teruggeleverdvandaag=`curl "http://127.0.0.1:8080/json.htm?type=devices&rid=5118"`
echo $teruggeleverdvandaag= > /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt
teruggeleverdvandaag=`cat /home/pi/domoticz/scripts/logging/weather_updates/weather-data2.txt | awk -F: '{print $35, $36}' | awk -F ', "' '{print $1}' | sed 's/"//g'`

echo -ne "Vandaag: "$gasvandaag" m3 gas verbruikt | "$opgewektvandaag" stroom opgewekt, waarvan "$teruggeleverdvandaag" teruggeleverd aan het net | "$verbruikvandaag" kWh stroom verbruikt, waarvan "$afgenomenvandaag" van het net gehaald | Totaal "$opgewekttotaal" kWh opgewekt en "$verbruiktotaal" kWh totaal verbruikt."> /home/pi/domoticz/scripts/logging/weather_updates/weather-tweet.txt

sudo python /home/pi/domoticz/scripts/python/weer_tweet.py