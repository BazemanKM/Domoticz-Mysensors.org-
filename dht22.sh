SERVER="192.168.2.3:8080"

# DHT IDX
# le numéro de l IDX dans la liste des peripheriques
DHTIDX="18"
#DHTPIN
# LE GPIO ou est connecte le DHT22
DHTPIN="17"

# si vous avez un DHT22 modifiez plus bas sur la ligne Adafruit_DHT 11 par Adafruit_DHT 22
# TMPFILE : chemin pour fichier temporaire a placer dans le RAMDRIVE pour eviter les
# ecritures sur la SD card
# sinon chemin ou sera ecrit le fichier contenant les temperature
# /tmp/temper.txt est un bon choix si pas de RAMDRIVE ins

TMPFILE="/var/tmp/temper.txt"
# modif de patrick du 08/03/15 pour interroger que 5 fois maxi
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
#echo $TEMP
#echo $HUM
# Send data
curl -s -i -H "Accept: application/json" "http://$SERVER/json.htm?type=command&param=udevice&idx=$DHTIDX&nvalue=0&svalue=$TEMP;$HUM;2"
TEMP=""
HUM=""
rm $TMPFILE
exit 0
fi
#echo $cpt
cpt=$(($cpt+1))
done
exit 1
