#!/bin/sh
now=$(date +"%T")

SnapFile="/var/tmp/opritcam.mp4"    # Temp name of the video, change it when using this script for multiple cams
VideoLength=5     # Seconds to record
WaitTime=10       # Seconds the script waits before it sends another video
User=admin         # Username which has access to the RTSP stream
Password=XXE86MFS   # Password for above provided user
rtspUrl="rtsp://192.168.2.6:554/mpeg4?username=admin&password=EFA0F43A0E9854B2F207C3918D088DE3"   # Use https://sourceforge.net/projects/onvifdm/ to find your correct RTSP stream url
ChatID=673222530    # Telegram chat ID   See https://www.domoticz.com/wiki/Installing_Telegram_Notification_System for setup instructions
TelegramAPIToken=623170584:AAEcrkjM_PtgItyhGZOr0lh1rfDulB_tqsk    # Telegram API token

filedate=`stat -L --format %Y $SnapFile`
retc=$?
if [ $retc -eq 0 ] ; then
        sec=$(( `date +%s`-$filedate))
        echo file found and age is $sec seconds
else
        sec=999
        echo File not found $SnapFile
fi
if [ $sec -gt $WaitTime ] ; then
        echo file older than $WaitTime seconds:  $sec sending video
        avconv -y -i $rtspUrl -r 30 -vcodec copy -an -t $VideoLength $SnapFile
        curl -s -F chat_id=$ChatID -F video="@$SnapFile" -F caption="$now Deurbel bijkeuken" https://api.telegram.org/bot$TelegramAPIToken/sendVideo
else
        echo There was another try within $WaitTime seconds: $sec
fi