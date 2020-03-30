    -- Weatherunderground PWS upload script
    -- (C)2013 GizMoCuz

    Outside_Temp_Hum = 'Zonnepanelen'

    --WU Settings
    baseurl = "http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?"
    ID = "IGRONING61"
    PASSWORD = "XXE86MFS"

    local function CelciusToFarenheit(C)
       return (C * (9/5)) + 32
    end

    local function hPatoInches(hpa)
       return hpa * 0.0295301
    end

    local function mmtoInches(mm)
       return mm * 0.039370
    end

    utc_dtime = os.date("!%m-%d-%y %H:%M:%S",os.time())

    month = string.sub(utc_dtime, 1, 2)
    day = string.sub(utc_dtime, 4, 5)
    year = "20" .. string.sub(utc_dtime, 7, 8)
    hour = string.sub(utc_dtime, 10, 11)
    minutes = string.sub(utc_dtime, 13, 14)
    seconds = string.sub(utc_dtime, 16, 17)

    timestring = year .. "-" .. month .. "-" .. day .. "+" .. hour .. "%3A" .. minutes .. "%3A" .. seconds

    SoftwareType="Domoticz"

    WU_URL= baseurl .. "ID=" .. ID .. "&PASSWORD=" .. PASSWORD .. "&dateutc=" .. timestring
    --&winddir=230
    --&windspeedmph=12
    --&windgustmph=12

    if Outside_Temp_Hum ~= '' then
       WU_URL = WU_URL .. "&tempf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_temperature[Outside_Temp_Hum]))
     end

    --&weather=
    --&clouds=

    WU_URL = WU_URL .. "&softwaretype=" .. SoftwareType .. "&action=updateraw"

    --print (WU_URL)

    commandArray = {}

    --remove the line below to actualy upload it
    commandArray['OpenURL']=WU_URL

    return commandArray
