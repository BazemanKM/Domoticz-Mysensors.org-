local FQDN = 'luftdaten.xxxx.xx'

return {
        active = true,
        on = {
                timer = { 'every minute' },
                httpResponses = { 'luftdatenRetrieved' } -- matches callback string below
        },
        execute = function(domoticz, item)

                if (item.isTimer) then
                        domoticz.openURL({
                                url = 'http://192.168.2.44/data.json',
                                method = 'GET',
                                callback = 'luftdatenRetrieved'
                        })

                elseif (item.isHTTPResponse) then
                        if (item.ok and item.isJSON) then -- statusCode == 2xx
                                if tonumber(item.json.age) < 60 then
-- 1: SDS_P1 PM10, 2: SDS_P2 PM2.5, 3: DHT22 temp, 4: DHT22 hum, 5: BME280 temp, 6: BME280 hum, 7: BME280 baro
                                        domoticz.devices('Luftdaten PM10').updateCustomSensor(item.json.sensordatavalues[1].value)
                                        domoticz.devices('Luftdaten PM2.5').updateCustomSensor(item.json.sensordatavalues[2].value)
                                        domoticz.devices('Luftdaten DHT22').updateTempHum(item.json.sensordatavalues[3].value,item.json.sensordatavalues[4].value,0)
-- Comment out the next 3 lines if you dont have the BME280 sensor
                                        if (tonumber (item.json.sensordatavalues[5].value) < 100) and (tonumber (item.json.sensordatavalues[7].value)/100 < 1050) then
                                                domoticz.devices('Luftdaten BME280').updateTempHumBaro(item.json.sensordatavalues[5].value,item.json.sensordatavalues[6].value,0,(item.json.sensordatavalues[7].value/100),0)
                                        end
                                end
                        else
                                -- oops
                                domoticz.log('Error fetching Luftdaten data', domoticz.LOG_ERROR)
                                domoticz.log(item.data, domoticz.LOG_ERROR)
                        end
                end
        end
}
