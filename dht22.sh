SERVER="192.168.2.3:8080"
DHTIDX="18"
DHTPIN="17"
TMPFILE="/var/tmp/temper.txt"
cpt=0
while [ $cpt -lt 6 ]
do
TEMP=""
sleep 5
sudo nice -20 Adafruit_DHT 22 $DHTPIN > $TMPFILE
TEMP=$(cat $TMPFILE|grep Temp |awk '{print $3}')
if [ $TEMP ]
then
TEMP=$(cat $TMPFILE|grep Temp |awk '{print $3}')
HUM=$(cat $ $TMPFILE |grep Temp |awk '{print $7}')
curl -s -i -H "Accept: application/json" "http://$SERVER/json.htm?type=command&param=udevice&idx=$DHTIDX&nvalue=0&svalue=$TEMP;$HUM;2"
TEMP=""
HUM=""
rm $TMPFILE
exit 0
fi
cpt=$(($cpt+1))
done
exit 1
