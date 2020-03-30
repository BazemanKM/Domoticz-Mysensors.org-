--[[ Version 0.20180512

    updateWeatherSensors (  Dutch locations only
                            dzVents > 2.4.0
                            Create virtual hardware: Dummy (Does nothing, use for virtual switches only)
                            Create virtual sensors (use button on the just created virtual device)
                            Types:      Temp+Humidity                      --
                                        Wind+Temp+Chill                    -- Pick this and/or next one (or neither one )
                                        Wind                               -- Pick this and/or previous one (or neither one )
                                        Temp                               -- If you choose to seperate windchill from winddevice
                                        Rain
                                        Barometer
                                        Visibility
                                        Solar Radiation
                                        Text                                -- weatherForecastLong and -short, rainAlarmtext
                                        Text                                -- 5 and 10 day weather forecast
                                        Custom Sensor                       -- Both rainForecast devices
                                        Switch                              -- rainForecast switch
                                        Alert                               -- rainForecast alert
                                        Lux                                 -- Estimated Lux based on Solar Radiation and weather description

                                        Note: You only have to define the sensors / switches you want to use

Please be aware the the Lux value calculated in this script is a very rough estimate on what the Lux could be.
It is based on the Solar Radiation value from Buienradar, the relative time after sunset and the weather description.
Especial in the higher ranger it can be off significantly.
For a better approach of a calculated Lux value please have a look at

http://www.domoticz.com/forum/viewtopic.php?f=72&t=19220
http://www.domoticz.com/forum/viewtopic.php?f=61&t=10077

 set devices and settings in setting file "domoticz dir"/scripts/dzVents/scripts/modules/wusSettings.lua
 set functions in function file "domoticz dir"/scripts/dzVents/scripts/modules/wusFunctions.lua
 set errorMessages in messagefile "domoticz dir"/scripts/dzVents/scripts/modules/wusErrors.lua
 before moving this script to its final place. devices to be identified by their numeric IDX

possible weather stations (20180416):

City / Location         Weatherstation
================        ==============
Amsterdam               Schiphol
Arnhem                  Arnhem
Berkhout                Berkhout
Den Helder              Den Helder
Eindhoven               Eindhoven
Enkhuizen-Lelystad      Houtribdijk
Gilze Rijen             Gilze Rijen
Goes                    Goes
Gorinchem               Herwijnen
Groningen               Groningen
Hoek van Holland        Hoek van Holland
Hoogeveen               Hoogeveen
Hoorn                   Wijdenes
IJmuiden                IJmuiden
Leeuwarden              Leeuwarden
Lelystad                Lelystad
Maastricht              Maastricht
Noord-Groningen         Lauwersoog
Noordoostpolder         Marknesse
Noordzee                Zeeplatform F-3
Noordzee                Zeeplatform K13
Oost-Groningen          Nieuw Beerta
Oost-Overijssel         Groenlo-Hupsel
Rotterdam               Rotterdam
Rotterdam Haven         Rotterdam Geulhaven
Schiermonnikoog         Huibertgat
Terneuzen               Westdorpe
Texel                   Texelhors
Twente                  Twente
Uden                    Volkel
Utrecht                 De Bilt
Venlo                   Arcen
Vlieland                Vlieland
Vlissingen              Vlissingen
Voorschoten             Voorschoten
Wadden                  Hoorn Terschelling
Weert                   Ell
West-Friesland          Stavoren
West-Utrecht            Lopik-Cabauw
Wijk aan Zee            Wijk aan Zee
Woensdrecht             Woensdrecht
Zwolle                  Heino

This script is based on various other scripts and plugins
found on the Domoticz forum. I gracefully borrowed code and
solutions from many contributers over here.

I hope that if you use it or get some ideas out of it, you will enjoy it
as much as I had when writing it.

I welcome all constructive comments, improvements and ideas.

Last but not least: Many thanks to dannybloe and others for dzVents

History
========
20180408 Start coding
20180411 First version active and shared on forum
20180412 Added check on text fields (do not overwrite same text)
20180413 Added more checks and logs
20180413 Corrected rain forecast formulas
20180413 Adjusted rain forecast devices
20180413 Added Alert,text and switch rain forecast devices (all optional)
20180414 User adjustable interval for Info logging to domoticz log-file
20180414 User adjustable interval for updating unchanged sensors/switches
20180414 Shortened long forecast string to 240 chars because of bug in domoticz
20180415 Separated user specific settings from main code-file
20180416 Improved layout text to log-file
20180420 Day-/night frequency now controlled by user-setting
20180423 Added checks on empty returns
20180423 Added experimental Lux based on Solar Power
20180424 Bug in rain-forecast fixed that caused the forecast being much too high
20180424 Improved Lux calculation based on SolarPower
20180425 Bug in updating rain-rate after forcedUpdateMinutes fixed (did not update when equal)
20180425 Prepared language choice
20180427 Added more translations
20180427 Added 5 and 10 day forecast device and information
20180429 Setting file mandatory now
20180429 Finished translations
20180429 Added location retrieval from domoticz settings
20180430 Adjusted Lux calculation
20180430 Fixed bug in Barometer setting (wrong dz.constants) and
20180430 Add setting for significant decimals in barometer
20180501 Get domoticzurl from system no longer required to give IP / Port in setting
20180502 Add option to separate windchill from wind device
20180504 More adjustments to Lux calculation based on SolarPower (thanks to poudeness)
20180504 Add file with Curle errors (Will be loaded in debug mode only)
20180505 Set weatherstation is now optional. Script gets nearby weatherstation based on longitude / latitude from domoticz
20180505 Script will get home address based on longitude / latitude from domoticz
20180506 Script will dump json Returns to file on request, -significant errors and when dz.LOG_DEBUG is active.
20180506 Script will load data from files in test-mode
20180507 Add option to get data from other nearby stations when getting specific data from initial station failed
20180508 Moved local vars to tables.
20180510 Moved functions to separate file
20180511 Made load data from files in test mode and dump json Returns to file mutual exclusive
20180512 Loglevel now in settings

todo:
=====
Short term:     bug fixing

Long term:      create hardware / devices if/when needed as to be defined in user settings
                when domoticz bug fixed. Use full length text for long weather forecast string
                improve Lua coding ( move more to modules, use inheritance, etc..)
                move to GIT

test results:
=============
load Errorfile in debugmode                                     : Script should continue with or without   ==>> OK
Setting file not present                                        : Should abort with message                ==>> OK
Setting file not accessible                                     : Should abort with message                ==>> OK
No location in domoticz                                         : Should give a warning in debug mode      ==>> OK
No access to domoticz settings                                  : Should give a warning                    ==>> OK
Error in setting file                                           : Should abort with message                ==>> OK
One device missing                                              : Should continue without messages         ==>> OK
Multiple devices missing                                        : Should continue without messages         ==>> OK
All devices missing                                             : Should continue with message             ==>> OK
External site not resp                                          : Should abort with message                ==>> OK  (on return)
All ext. sites not response                                     : Should abort with message                ==>> OK  (on return)
Test all complete languages                                     : All strings translated                   ==>> OK
Test all partial languages                                      : Untranslated strings in English          ==>> OK
Check unexpected settings                                       : No aborts                                ==>> OK
Check weather devices for unexpected results                    : No strange values                        ==>> OK
Save jsons to file on error and in debug mode                   : In domoticz and/or data dir              ==>> OK
Load jsons from file in test mode                               : Warning in logfile                       ==>> OK
Test prevention of conflict between useTestSet and writeToFile  : Should never go together                 ==>> OK
Test behaviour on absence of testSet files in useTestSet mode   : Should abort with message                ==>> OK
Test behaviour of different loglevels in setting file           : Debug mode should give all dbg messagesa ==>> OK
]] --

local RADARRESPONSE     = "WUS_buienradarResponse"
local RAINRESPONSE      = "WUS_rainForecastResponse"
local LOCATIONRESPONSE  = "WUS_locationResponse"
local ADDRESSRESPONSE   = "WUS_addressResponse"

return {
    on = {    timer =                { "every minute" },                         -- Actual execution frequency is by usersetting
              devices =            { "XButton-2" },                              -- I use this button to activate script during development and testing
              httpResponses =        {  "WUS*" }                                 -- When http api calls are answered it will trigger these
    },

    logging = {     level = domoticz.LOG_INFO,                                   -- Actual logLevel is set in UserSetting
                    marker = "WUS" },                                            -- Short for Weathersensors Update Script

                    data = {            lastInfoLogging         = { initial = 0 },
                                        minutesPastExecution    = { initial = 0 },            -- Used to control actual frequency
                                        domoticzLatitude        = { initial = 0},
                                        domoticzLongitude       = { initial = 0 },
                                        domoticzLocation        = { initial = "Nederland" },
                                        locationUpdated         = { initial = 0 },
            },

    execute = function(dz, trigger)

    -- Various tables containing devices, constants, vars, messages etc.
    INF            = {}            --  }
    DBG            = {}            --      }
    ALL            = {}            --           }
    ERR            = {}            --               }    Language aware messages
    MUL            = {}            --           ]
    TXT            = {}            --  }

    dev            = {}            -- devices
    const          = {}            -- Lua vars that will not change during execution
    var            = {}            -- Lua vars that can/will change during execution
    rt             = {}            -- ReturnTable
    dzW            = dz            -- To ensure a reference to the dz object is available in "require" files

    local function getUservars()
       require ('wusSettings')
    end

    if pcall(getUservars) then                                                                 -- use pcall to be able to test if call was successful
        myWeatherStation              = settings.myWeatherStation                              -- Name of Weatherstation !! not of the city/location as this is not unique
        dev.barometer                 = dz.devices(settings.barometer)                         -- Barometer
        dev.wind                      = dz.devices(settings.wind)                              -- Wind
        dev.justWind                  = dz.devices(settings.justWind)                          -- Wind
        dev.windChill                 = dz.devices(settings.windChill)                         -- Temperature
        dev.sight                     = dz.devices(settings.sight)                             -- visibility
        dev.sunlight                  = dz.devices(settings.sunlight)                          -- solar
        dev.lux                       = dz.devices(settings.lux)                               -- Calculated using sight value / time / others
        dev.rainRate                  = dz.devices(settings.rainRate)                          -- rain rate
        dev.tempHumidity              = dz.devices(settings.tempHumidity)                      -- Temp + Humidity
        dev.weatherForecastLong       = dz.devices(settings.weatherForecastLong)               -- Long weather forecast text
        dev.weatherForecastShort      = dz.devices(settings.weatherForecastShort)              -- Short weather forecast text
        dev.rainForecast_1_hour       = dz.devices(settings.rainForecast_1_hour)               -- Custom Sensor (x-as in mm/h)
        dev.rainForecast_2_hours      = dz.devices(settings.rainForecast_2_hours)              -- Custom Sensor (x-as in mm/h)
        dev.rainAlarm                 = dz.devices(settings.rainAlarm)                         -- rain forecastAlert device
        dev.rainAlarmText             = dz.devices(settings.rainAlarmText)                     -- rain forecastAlarm text
        dev.rainAlarmSwitch           = dz.devices(settings.rainAlarmSwitch)                   -- rain forecast Switch
        dev.weatherForecastFiveDays   = dz.devices(settings.weatherForecastFiveDays)           -- weather 5 day forecast text
        dev.weatherForecastTwoWeeks   = dz.devices(settings.weatherForecastTwoWeeks)           -- weather 14 day forecast text

        var.daytimeFrequencyMinutes   = settings.daytimeFrequencyMinutes or 12                  -- Execute every nn minutes during daytime
        var.displayInfoLogMinutes     = settings.displayInfoLogMinutes or 30                    -- Show info in domoticzlog
        var.displayLanguage           = settings.displayLanguage or "English"                   -- Choose one of the languages available ( Dutch, UK_English, German, Yoruba)
        var.forcedUpdateMinutes       = settings.forcedUpdateMinutes or 360                     -- Update sensors even when no change
        var.maxDistanceFromHome       = settings.maxDistanceFromHome or 75                      -- Only try weatherStations within this range in Km from home location
        var.nighttimeFrequencyMinutes = settings.nighttimeFrequencyMinutes or 24                -- Execute every nn minutes during nightime
        var.rainAlertAmount           = settings.rainAlertAmount or 0.02                        -- mm Rain to take serious
        var.rainAlertTime             = settings.rainAlertTime or 15                            -- Check rain in the next rainAlertTime minutes
        var.signDecimalsBaroDatabase  = settings.signDecimalsBaroDatabase or 2                  -- Use significant decimals in barometer value (in database)
        var.signDecimalsBaroDisplay   = settings.signDecimalsBaroDisplay or 0                   -- Use significant decimals in barometer display
        var.startDaytimeHour          = settings.startDaytimeHour or 7                          -- After this hour until NighttimeHour, DaytimeFrequency will be used
        var.startNighttimeHour        = settings.startNighttimeHour or 22                       -- After this hour until DaytimeHour, DaytimeFrequency will be used
        var.useDomoticzLocation       = settings.useDomoticzLocation or true                    -- Use location set in domoticz for nearby weatherStation and rain forecast
        var.useNearestWeatherStation  = settings.useNearestWeatherStation or true               -- when set station does not provide all data
        var.devicesDefined            = 0                                                       -- Used in check for number of weather related devices defined in Domoticz
        var.displayInfoLog            = ( var.displayInfoLogMinutes == nil or                   -- true if not defined or 99
                                          var.displayInfoLogMinutes == 99 )

        -- For development / problem solving only
        var.testSetDirectory          = settings.testSetDirectory or "./scripts/dzVents/data/"  -- Location of the testSets
        var.useTestSet                = settings.useTestSet or false                            -- When true this will trigger dummy URL's and get the data to be processed from OS files
        var.forceWrite2Files          = settings.forceWrite2Files or false                      -- This will force the data coming back from the HTTP calls to be written to files
        var.logLevel                  = settings.logLevel or dz.LOG_INFO                         -- set requested logLevel

        -- set Global logLevel
        _G.logLevel                 = var.logLevel

    else
        local status, err = pcall(getUservars)
        dz.log("\n\n ********   Error  ********* \n\n       " .. err .. "\n\n" , dz.LOG_ERROR)               -- No usersetting file So we quit

        dz.log("User settings file unusable or not present", dz.LOG_ERROR)                                   -- No usersetting file So we quit
        dz.log("Gebruikers instellingen file kan niet worden geladen. Verwerking stopt.", dz.LOG_ERROR)      -- No usersetting file So we quit
        return
    end

     -- constants (devicetypes)
    const.ALARM                 = "Alert"
    const.BAR                   = "Barometer"
    const.CUST                  = "Custom Sensor"
    const.GENERAL               = "General"
    const.LUX                   = "Lux"
    const.RAIN                  = "Rain"
    const.SUN                   = "Solar Radiation"
    const.SWITCH                = "Light/Switch"
    const.TEMPERATURE           = "Temp"
    const.TEMPHUMIDITY          = "Temp + Humidity"
    const.TEXT                  = "Text"
    const.VISI                  = "Visibility"
    const.WIND                  = "Wind"

    -- constants (various)
    const.ARROWPOSITION         = 40
    const.DEFAULTLENGTH         = 70
    const.DEVICEPOSITION        = 65
    const.INFOPOSITION          = 45
    const.LABELPOSITION         = 18
    const.LINELENGTH            = 145                           -- For the dash lines
    const.TESTSETAGESECONDS     = 12 * 60 * 60

    const.LOGLEVEL              = var.logLevel

    const.TRIGGERNAME           = trigger.trigger
    const.TYPEPOSITION          = 47

    const.SWRAP                 = "begin"
    const.EWRAP                 = "end"
    const.BWRAP                 = "both"

    const.ADDRESSURL            = "http://maps.googleapis.com/maps/api/geocode/json?latlng=latitude,longitude&sensor=true"
    const.LOCATIONURL           = dz.settings['Domoticz url'] ..  "/json.htm?type=settings"
    const.RAINURL               = "https://gadgets.buienradar.nl/data/raintext"
    const.TESTURL               = dz.settings['Domoticz url'] ..  "/json.htm?type=command&param=addlogmessage&message=WUS:%20are%20you%20alive%20"
    const.WEATHERURL            = "https://api.buienradar.nl/data/public/1.1/jsonfeed"

    const.ADDRESSDATA           = var.testSetDirectory .. "AddressResponse.json"
    const.BUIENRADARDATA        = var.testSetDirectory .. "BuienradarResponse.json"
    const.LOCATIONDATA          = var.testSetDirectory .. "LocationResponse.json"
    const.RAINDATA              = var.testSetDirectory .. "RainResponse.flat"

    -- Strings in chosen language

   DBG.AIRPRESSURE            = languages[var.displayLanguage].DBG_AIRPRESSURE             or languages.English.DBG_AIRPRESSURE
   DBG.DESCFACTOR             = languages[var.displayLanguage].DBG_DESCFACTOR              or languages.English.DBG_DESCFACTOR
   DBG.CURLEMESSAGESLOADED    = languages[var.displayLanguage].DBG_CURLEMESSAGESLOADED     or languages.English.DBG_CURLEMESSAGESLOADED
   DBG.CURLEMESSAGESNOTLOADED = languages[var.displayLanguage].DBG_CURLEMESSAGESNOTLOADED  or languages.English.DBG_CURLEMESSAGESNOTLOADED
   DBG.FOUND                  = languages[var.displayLanguage].DBG_FOUND                   or languages.English.DBG_FOUND
   DBG.ISTYPE                 = languages[var.displayLanguage].DBG_ISTYPE                  or languages.English.DBG_ISTYPE
   DBG.LOCATIONPROBLEM        = languages[var.displayLanguage].DBG_LOCATIONPROBLEM         or languages.English.DBG_LOCATIONPROBLEM
   DBG.MAXALTERNATIVES        = languages[var.displayLanguage].DBG_MAXALTERNATIVES         or languages.English.DBG_MAXALTERNATIVES
   DBG.NOEXECUTION            = languages[var.displayLanguage].DBG_NOEXECUTION             or languages.English.DBG_NOEXECUTION
   DBG.NORAINEXPEXTED1HOUR    = languages[var.displayLanguage].DBG_NORAINEXPEXTED1HOUR     or languages.English.DBG_NORAINEXPEXTED1HOUR
   DBG.NOUSERSETTING          = languages[var.displayLanguage].DBG_NOUSERSETTING           or languages.English.DBG_NOUSERSETTING
   DBG.NOW                    = languages[var.displayLanguage].DBG_NOW                     or languages.English.DBG_NOW
   DBG.NOWEATHERSTATION       = languages[var.displayLanguage].DBG_NOWEATHERSTATION        or languages.English.DBG_NOWEATHERSTATION
   DBG.RAINRATESAME           = languages[var.displayLanguage].DBG_RAINRATESAME            or languages.English.DBG_RAINRATESAME
   DBG.SHOULDITRIGGER         = languages[var.displayLanguage].DBG_SHOULDITRIGGER          or languages.English.DBG_SHOULDITRIGGER
   ERR.ADDRESSNOTFOUND        = languages[var.displayLanguage].ERR_ADDRESSNOTFOUND         or languages.English.ERR_ADDRESSNOTFOUND
   ERR.CONVERSIONPROBLEM      = languages[var.displayLanguage].ERR_CONVERSIONPROBLEM       or languages.English.ERR_CONVERSIONPROBLEM
   ERR.LOCATIONNOTFOUND       = languages[var.displayLanguage].ERR_LOCATIONNOTFOUND        or languages.English.ERR_LOCATIONNOTFOUND
   ERR.LOOKUPFAILED           = languages[var.displayLanguage].ERR_LOOKUPFAILED            or languages.English.ERR_LOOKUPFAILED
   ERR.NOTFOUND               = languages[var.displayLanguage].ERR_NOTFOUND                or languages.English.ERR_NOTFOUND
   ERR.TRIGGERERROR           = languages[var.displayLanguage].ERR_TRIGGERERROR            or languages.English.ERR_TRIGGERERROR
   ERR.UNKNOWNEVENT           = languages[var.displayLanguage].ERR_UNKNOWNEVENT            or languages.English.ERR_UNKNOWNEVENT
   ERR.WEATHERSTATIONPROBLEM  = languages[var.displayLanguage].ERR_WEATHERSTATIONPROBLEM   or languages.English.ERR_WEATHERSTATIONPROBLEM
   ERR.WRONGPORTORIP          = languages[var.displayLanguage].ERR_WRONGPORTORIP           or languages.English.ERR_WRONGPORTORIP
   INF.ALERTLEVEL             = languages[var.displayLanguage].INF_ALERTLEVEL              or languages.English.INF_ALERTLEVEL
   INF.ARROW                  = languages[var.displayLanguage].INF_ARROW                   or languages.English.INF_ARROW
   INF.BAROCLOUDY             = languages[var.displayLanguage].INF_BAROCLOUDY              or languages.English.INF_BAROCLOUDY
   INF.BAROCLOUDYRAIN         = languages[var.displayLanguage].INF_BAROCLOUDYRAIN          or languages.English.INF_BAROCLOUDYRAIN
   INF.BAROFORECAST           = languages[var.displayLanguage].INF_BAROFORECAST            or languages.English.INF_BAROFORECAST
   INF.BAROSTABLE             = languages[var.displayLanguage].INF_BAROSTABLE              or languages.English.INF_BAROSTABLE
   INF.BAROSUNNY              = languages[var.displayLanguage].INF_BAROSUNNY               or languages.English.INF_BAROSUNNY
   INF.BAROTHUNDERSTORM       = languages[var.displayLanguage].INF_BAROTHUNDERSTORM        or languages.English.INF_BAROTHUNDERSTORM
   INF.BAROUNSTABLE           = languages[var.displayLanguage].INF_BAROUNSTABLE            or languages.English.INF_BAROUNSTABLE
   INF.CALCLUX                = languages[var.displayLanguage].INF_CALCLUX                 or languages.English.INF_CALCLUX
   INF.CANNOTCALCULATE        = languages[var.displayLanguage].INF_CANNOTCALCULATE         or languages.English.INF_CANNOTCALCULATE
   INF.CELSIUS                = languages[var.displayLanguage].INF_CELSIUS                 or languages.English.INF_CELSIUS
   INF.CURRENT                = languages[var.displayLanguage].INF_CURRENT                 or languages.English.INF_CURRENT
   INF.DEGREES                = languages[var.displayLanguage].INF_DEGREES                 or languages.English.INF_DEGREES
   INF.DEVICE                 = languages[var.displayLanguage].INF_DEVICE                  or languages.English.INF_DEVICE
   INF.DEWPOINT               = languages[var.displayLanguage].INF_DEWPOINT                or languages.English.INF_DEWPOINT
   INF.FIVEDAYS               = languages[var.displayLanguage].INF_FIVEDAYS                or languages.English.INF_FIVEDAYS
   INF.FORECAST               = languages[var.displayLanguage].INF_FORECAST                or languages.English.INF_FORECAST
   INF.GUST                   = languages[var.displayLanguage].INF_GUST                    or languages.English.INF_GUST
   INF.HUMCOMFORTABLE         = languages[var.displayLanguage].INF_HUMCOMFORTABLE          or languages.English.INF_HUMCOMFORTABLE
   INF.HUMDRY                 = languages[var.displayLanguage].INF_HUMDRY                  or languages.English.INF_HUMDRY
   INF.HUMIDITY               = languages[var.displayLanguage].INF_HUMIDITY                or languages.English.INF_HUMIDITY
   INF.HUMNORMAL              = languages[var.displayLanguage].INF_HUMNORMAL               or languages.English.INF_HUMNORMAL
   INF.HUMWET                 = languages[var.displayLanguage].INF_HUMWET                  or languages.English.INF_HUMWET
   INF.MMH                    = languages[var.displayLanguage].INF_MMH                     or languages.English.INF_MMH
   INF.NEXT2HOURS             = languages[var.displayLanguage].INF_NEXT2HOURS              or languages.English.INF_NEXT2HOURS
   INF.NEXTHOUR               = languages[var.displayLanguage].INF_NEXTHOUR                or languages.English.INF_NEXTHOUR
   INF.NODEVICE               = languages[var.displayLanguage].INF_NODEVICE                or languages.English.INF_NODEVICE
   INF.NODEVICESDEFINED       = languages[var.displayLanguage].INF_NODEVICESDEFINED        or languages.English.INF_NODEVICESDEFINED
   INF.NOMEASUREDVALUE        = languages[var.displayLanguage].INF_NOMEASUREDVALUE         or languages.English.INF_NOMEASUREDVALUE
   INF.NONE                   = languages[var.displayLanguage].INF_NONE                    or languages.English.INF_NONE
   INF.NOWEATHERSTATIONS      = languages[var.displayLanguage].INF_NOWEATHERSTATIONS       or languages.English.INF_NOWEATHERSTATIONS
   INF.PRESSURE               = languages[var.displayLanguage].INF_PRESSURE                or languages.English.INF_PRESSURE
   INF.RAIN                   = languages[var.displayLanguage].INF_RAIN                    or languages.English.INF_RAIN
   INF.RAINALARM              = languages[var.displayLanguage].INF_RAINALARM               or languages.English.INF_RAINALARM
   INF.RAINALERT              = languages[var.displayLanguage].INF_RAINALERT               or languages.English.INF_RAINALERT
   INF.RAINFORECAST           = languages[var.displayLanguage].INF_RAINFORECAST            or languages.English.INF_RAINFORECAST
   INF.RAINTOTAL              = languages[var.displayLanguage].INF_RAINTOTAL               or languages.English.INF_RAINTOTAL
   INF.SHORT                  = languages[var.displayLanguage].INF_SHORT                   or languages.English.INF_SHORT
   INF.SOLARPOWER             = languages[var.displayLanguage].INF_SOLARPOWER              or languages.English.INF_SOLARPOWER
   INF.SUMMARY                = languages[var.displayLanguage].INF_SUMMARY                 or languages.English.INF_SUMMARY
   INF.SWITCH                 = languages[var.displayLanguage].INF_SWITCH                  or languages.English.INF_SWITCH
   INF.TEMPERATURE            = languages[var.displayLanguage].INF_TEMPERATURE             or languages.English.INF_TEMPERATURE
   INF.TESTSETWARNING         = languages[var.displayLanguage].INF_TESTSETWARNING          or languages.English.INF_TESTSETWARNING
   INF.TWOWEEKS               = languages[var.displayLanguage].INF_TWOWEEKS                or languages.English.INF_TWOWEEKS
   INF.VISIBILITY             = languages[var.displayLanguage].INF_VISIBILITY              or languages.English.INF_VISIBILITY
   INF.WEATHERFORECASTPHRASE  = languages[var.displayLanguage].INF_WEATHERFORECASTPHRASE   or languages.English.INF_WEATHERFORECASTPHRASE
   INF.WIND                   = languages[var.displayLanguage].INF_WIND                    or languages.English.INF_WIND
   INF.WINDCHILL              = languages[var.displayLanguage].INF_WINDCHILL               or languages.English.INF_WINDCHILL
   INF.WINDSPEED              = languages[var.displayLanguage].INF_WINDSPEED               or languages.English.INF_WINDSPEED
   MUL.MINUTES                = languages[var.displayLanguage].MUL_MINUTES                 or languages.English.MUL_MINUTES
   MUL.MMRAIN                 = languages[var.displayLanguage].MUL_MMRAIN                  or languages.English.MUL_MMRAIN
   MUL.NORAINEXPECTED         = languages[var.displayLanguage].MUL_NORAINEXPECTED          or languages.English.MUL_NORAINEXPECTED
   MUL.THEREWILLBE            = languages[var.displayLanguage].MUL_THEREWILLBE             or languages.English.MUL_THEREWILLBE
   TXT.GREEN                  = languages[var.displayLanguage].TXT_GREEN                   or languages.English.TXT_GREEN
   TXT.GREY                   = languages[var.displayLanguage].TXT_GREY                    or languages.English.TXT_GREY
   TXT.ORANGE                 = languages[var.displayLanguage].TXT_ORANGE                  or languages.English.TXT_ORANGE
   TXT.RED                    = languages[var.displayLanguage].TXT_RED                     or languages.English.TXT_RED
   TXT.YELLOW                 = languages[var.displayLanguage].TXT_YELLOW                  or languages.English.TXT_YELLOW

    -- get current Time into now
    local Time  = require("Time")
    local now   = Time()

    local function getFunctions()
        fn = require("wusFunctions")
    end

    if pcall(getFunctions) then
        dz.log("getFunctions loaded",dz.LOG_DEBUG)
    else
        local status, err = pcall(getFunctions)
        dz.log("\n\n ********   Error  ********* \n\n       " .. err .. "\n\n" , dz.LOG_ERROR)               -- No Functions -->> we quit

        dz.log("Required functions (file) unusable or not present", dz.LOG_ERROR)                                   -- No usersettting file So we quit
        dz.log("Vereiste functies kunnen niet worden geladen. Verwerking stopt.", dz.LOG_ERROR)      -- No usersettting file So we quit
        return
    end

    -- Load CURLE messages when in debug mode
    local TRIGGERERROR   = {}
    if const.LOGLEVEL == dz.LOG_DEBUG then
        local function getErrorMessages()
            require ('wusErrors')
        end
        if pcall(getErrorMessages) then
            dz.log(DBG.CURLEMESSAGESLOADED ,dz.LOG_DEBUG)
        else
            dz.log(DBG.CURLEMESSAGESNOTLOADED ,dz.LOG_DEBUG)
        end
    end

    -- Check and correct mutual exclusive settings and age of
    if var.forceWrite2Files then
        if var.useTestSet then
            var.forceWrite2Files  = false                         -- This will not work together
            dz.log("Invalid combination of useTestSet and forceWrite2Files",dz.LOG_ERROR)
        elseif fn.getModSecondsAgo (const.BUIENRADARDATA) <  const.TESTSETAGESECONDS then
            dz.log("TestSet is too recent to be refreshed",dz.LOG_INFO)
            var.forceWrite2Files  = false                    --  testDataSet is recent
        else
            var.useTestSet = false                           -- This will not work together
        end
    end

    --- Should we infolog ?
    if dz.data.lastInfoLogging == 0 or ( ( dz.data.lastInfoLogging + 60 * var.displayInfoLogMinutes ) < now.secondsSinceMidnight ) or
                                         ( dz.data.lastInfoLogging > now.secondsSinceMidnight ) and
                                         var.displayInfoLogMinutes ~= 0 then
        var.displayInfoLog = true
        dz.data.lastInfoLogging = now.secondsSinceMidnight + 30
    end

    --- Should we update sensors switch even when no change ?
    if var.forcedUpdateMinutes == 0 then
        var.forcedUpdateMinutes = 0xfffffffffff
    elseif var.forcedUpdateMinutes == 99 then
        var.forcedUpdateMinutes = 0
    end

    -- Check and prevent further errors for WeatherStation
    if myWeatherStation == nil or myWeatherStation == "" or myWeatherStation == "Please enter your weatherstation here" then
        dz.log(DBG.NOWEATHERSTATION, dz.LOG_DEBUG)
        myWeatherStation         = "Rotterdam"
    end

    if const.TRIGGERNAME == RADARRESPONSE  then                                                -- There is our JSON file from first openURL
        var.found = false
        myWeatherStation = "Meetstation " ..  myWeatherStation                          -- Complete the name of the station
        if trigger.ok then                                                                         -- statusCode == 2xx

            if var.forceWrite2Files then
                dz.log("Create datafile: " .. const.BUIENRADARDATA,dz.LOG_DEBUG)
                fn.writeTestData(dz.utils.toJSON(trigger.json),const.BUIENRADARDATA)
            end

            -- local myData

            if var.useTestSet then
                if fn.fileExists(const.BUIENRADARDATA) then
                    -- Get the json from testFile and put it in the resultTable table
                    trigger.json= dz.utils.fromJSON(fn.getDataFromFile (const.BUIENRADARDATA))
                    var.testFileDate = fn.getFileDate (const.BUIENRADARDATA)
                else
                    local directory,separator = fn.getCurrentDir()
                    dz.log("directory " .. " ===>> " .. tostring(t), dz.LOG_ERROR)
                    dz.log("required datafile" .. "(" .. fn.getCurrentDir() ..
                            const.BUIENRADARDATA:gsub("%./",separator):gsub("%.\\",separator) ..
                            ")" .. " does not exist !!  "  .. " Script abort.",dz.LOG_ERROR)
                    return
                end
            end

            -- Convert the json to a LUA table
            if trigger.json ~= nil then
                if trigger.json.buienradarnl.weergegevens.actueel_weer.weerstations ~= nil then                     -- this sometimes happens around midnight
                    if trigger.json.buienradarnl.weergegevens.actueel_weer.weerstations.weerstation ~= nil then
                        rt  = trigger.json.buienradarnl.weergegevens.actueel_weer.weerstations.weerstation
                        dz.log("Number of entries in weatherstation array: " .. #rt, dz.LOG_DEBUG)
                    end
                else
                    dz.log(INF.NOWEATHERSTATIONS,dz.LOG_INFO)
                    return
                end
            end

            if rt ~= nil then                                                   -- Something wrong with the access to weerstations API
                local BaseIndex, i                                              -- various indexCounters for ipairs

                -- get indexNumber of weatherStation nearby
                if  var.useDomoticzLocation then
                   i,myWeatherStation =  fn.findHomeWeatherStation(rt)                                     -- get indexNumber of weatherStation nearby  using domoticz lat/lon
                else
                   i = fn.findHomeWeatherStation(rt,myWeatherStation)                                      -- get indexNumber of weatherStation nearby using myWeatherstation name
                end
                if rt[i].stationnaam["#text"] ~= nil then
                    var.found = true
                end

                dz.log("myWeatherStation.stationnaam in main: " .. tostring(rt[i].stationnaam["#text"]),dz.LOG_DEBUG)

                -- fill array with stationnames and distances (weatherStations nearby)
                fn.findNearbyWeatherStations ( rt[i] )
                dz.log("Distance: " .. rt[i].nearbyDistance[1],dz.LOG_DEBUG)

                -- fill array with stationnames and distances (weatherStations nearby)
                fn.sortNearbyWeatherStations ( rt[i] )

                if const.LOGLEVEL == dz.LOG_DEBUG then
                    fn.dump2File(dz.utils.toJSON(trigger.json),const.BUIENRADARDATA .. "_DEBUG")
                end

                if rt[i].stationnaam["#text"] ~= myWeatherStation  then
                  -- this should not happen
                    dz.log(ERR.LOOKUPFAILED .. rt[i].stationnaam["#text"],dz.LOG_ERROR)
                    fn.dump2File(dz.utils.toJSON(rt[i]),"ERR.stationnaam.dmp")
                    return
                else
                    dz.log(myWeatherStation .. fn.wrapSpaces(DBG.FOUND,const.SWRAP), dz.LOG_DEBUG)

                    if var.useNearestWeatherStation then
                        maxIndex = fn.traverseNearbyLocations ( rt[i] )
                        dz.log("Max " .. maxIndex .. " Alternative weatherStation will considered on absent value" , dz.LOG_DEBUG)
                    else
                        maxIndex = 0                 -- User want no alternative weatherStations
                    end
                    BaseIndex = i

                    fn.infoLog(fn.rightPad('-',const.LINELENGTH,'-'))
                    if var.useTestSet then
                        var.testSetWarning = fn.leftPad(fn.rightPad(fn.wrapSpaces(INF.TESTSETWARNING .."(" ..var.testFileDate .. ")"),85,"*"),90,"*")
                    else
                        var.testSetWarning = ""
                    end
                    fn.infoLog (var.testSetWarning)

                    if var.useDomoticzLocation then
                        fn.infoLog(fn.rightPad("Home: " .. dz.data.domoticzLocation ..". Basis-station: " .. rt[i].stationnaam["#text"]  ))
                    else
                        fn.infoLog(fn.rightPad(fn.wrapSpaces("Basis-station: ",const.SWRAP,20) .. rt[i].stationnaam["#text"]  ))
                    end
                    fn.infoLog(fn.rightPad('-',const.LINELENGTH,'-'))

                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if tonumber(rt[i].luchtdruk) ~= nil or r >= maxIndex then
                            var.processed = true                            -- Check and update Barometer
                            if fn.handleGenericDevice(dev.barometer, const.BAR) and tonumber(rt[i].luchtdruk) ~= nil then
                                local formatString = "%." .. var.signDecimalsBaroDatabase .."f"
                                 dev.barometer.updateBarometer ( string.format(formatString,rt[i].luchtdruk),           -- Pressure in HPA
                                                                    fn.BarometerForecast(tonumber(rt[i].luchtdruk)))  -- same as in Buienradar plugin
                            end

                            if tonumber(rt[i].luchtdruk) ~= nil then
                                local formatString = "%." .. var.signDecimalsBaroDisplay .."f"
                                fn.infoLog(fn.rightPad(fn.rightPad(INF.PRESSURE,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) ..
                                        fn.wrapSpaces(string.format(formatString,rt[i].luchtdruk),const.EWRAP) .. "HPa," ..
                                        fn.wrapSpaces(INF.BAROFORECAST) .. fn.barometerForecastInfo(tonumber(rt[i].luchtdruk))) ..
                                        var.deviceDefined  .. var.backupStation)
                            else
                                fn.infoLog    (   fn.rightPad   (fn.rightPad(INF.PRESSURE,const.LABELPOSITION) ..
                                                    fn.wrapSpaces(INF.ARROW) .. INF.NOMEASUREDVALUE )  .. var.deviceDefined )
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    -- Check and update Wind (related) sensors
                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if (( tonumber(rt[i].windsnelheidMS) ~= nil  and tonumber(rt[i].temperatuurGC) ~= nil )  or r >= maxIndex ) then
                            var.processed = true
                            local windDisplayed = false
                            if fn.handleGenericDevice(dev.wind, const.WIND) then
                               fn.handleWindDevice(dev.wind,rt[i])
                               fn.handleWindInfo(rt[i])
                               windDisplayed = true
                            end
                            if fn.handleGenericDevice(dev.justWind, const.WIND) then
                               fn.handleWindDevice(dev.justWind,rt[i])
                               if not(windDisplayed) then
                                    fn.handleWindInfo(rt[i])
                                    windDisplayed = true
                                end
                            end
                            if not(windDisplayed) then
                                    fn.handleWindInfo(rt[i])
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if (tonumber(rt[i].windsnelheidMS) ~= nil and  tonumber(rt[i].temperatuurGC) ~= nil) or r >= maxIndex then
                            var.processed = true
                            if fn.handleGenericDevice(dev.windChill,const.TEMPERATURE) then
                                dev.windChill.updateTemperature( fn.windChill
                                            (  fn.checkForNil(tonumber(rt[i].windsnelheidMS),0),
                                               fn.checkForNil(tonumber(rt[i].temperatuurGC),0 ) ))
                                fn.infoLog(   fn.rightPad(fn.rightPad(INF.WINDCHILL,const.LABELPOSITION)  .. fn.wrapSpaces(INF.ARROW) ..
                                                fn.windChill  (   fn.checkForNil(tonumber(rt[i].windsnelheidMS),0),
                                                fn.checkForNil(tonumber(rt[i].temperatuurGC),0 )) ..
                                                INF.CELSIUS) .. var.deviceDefined .. var.backupStation)
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                   until var.processed

                    -- Check and update Visibility sensor

                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if tonumber(rt[i].zichtmeters) ~= nil or r >= maxIndex then
                            var.processed = true
                            if fn.handleGenericDevice(dev.sight,const.VISI) then

                                dev.sight.updateVisibility(fn.checkForNil(tonumber(rt[i].zichtmeters),0) / 1000)
                            end
                            if tonumber(rt[i].zichtmeters) ~= nil then
                                fn.infoLog(fn.rightPad(fn.rightPad(INF.VISIBILITY,const.LABELPOSITION)  ..
                                        fn.wrapSpaces(INF.ARROW) .. (rt[i].zichtmeters) / 1000 .. " km") ..
                                        var.deviceDefined .. var.backupStation )
                            else
                                fn.infoLog(fn.rightPad(fn.rightPad(INF.VISIBILITY,const.LABELPOSITION)  .. fn.wrapSpaces(INF.ARROW) .. INF.NOMEASUREDVALUE )  ..
                                var.deviceDefined .. var.backupStation)
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    -- Check and update Solar power sensor
                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if tonumber(rt[i].zonintensiteitWM2) ~= nil or r >= maxIndex then
                            var.processed = true
                            if fn.handleGenericDevice(dev.sunlight,const.SUN) then
                                if tonumber(rt[i].zonintensiteitWM2) ~= nil then
                                    if tonumber(rt[i].zonintensiteitWM2) < 4 then
                                        dev.sunlight.updateRadiation(0)
                                    else
                                        dev.sunlight.updateRadiation(fn.checkForNil(tonumber(rt[i].zonintensiteitWM2),0 ))                  -- Solar intensity in Watt/m2
                                    end
                                end
                            end
                            if tonumber(rt[i].zonintensiteitWM2) ~= nil then
                                if tonumber(rt[i].zonintensiteitWM2) < 4 then
                                    fn.infoLog(fn.rightPad(fn.rightPad(INF.SOLARPOWER,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) ..
                                       "0 Watt/m2") .. var.deviceDefined )
                                else
                                    fn.infoLog(fn.rightPad(fn.rightPad(INF.SOLARPOWER,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) ..
                                        rt[i].zonintensiteitWM2  .. " Watt/m2") .. var.deviceDefined .. var.backupStation)
                                end
                            else
                                fn.infoLog(fn.rightPad(fn.rightPad(INF.SOLARPOWER,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) .. INF.NOMEASUREDVALUE )  .. var.deviceDefined )
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    -- Check and update calculated LUX sensor
                    local weatherDescription
                    if rt[i].icoonactueel["@zin"] ~= nil then
                        weatherDescription = rt[i].icoonactueel["@zin"]
                    else
                        weatherDescription = ""
                    end

                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if tonumber(rt[i].zonintensiteitWM2) ~= nil or r >= maxIndex then
                            var.processed = true
                            if fn.handleGenericDevice(dev.lux,const.LUX) then
                                dev.lux.updateLux(fn.calculateLux(fn.checkForNil(tonumber(rt[i].zonintensiteitWM2),0),weatherDescription))
                            end
                            if tonumber(rt[i].zonintensiteitWM2) ~= nil then
                                fn.infoLog    (   fn.rightPad(fn.rightPad(INF.CALCLUX,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) ..
                                                    fn.calculateLux(fn.checkForNil( tonumber(rt[i].zonintensiteitWM2 ) ,0 ) ,weatherDescription)  ..
                                                    " Lumen") .. var.deviceDefined .. var.backupStation )
                            else
                                fn.infoLog(   fn.rightPad(fn.rightPad(INF.CALCLUX,const.LABELPOSITION) ..
                                                fn.wrapSpaces(INF.ARROW) .. INF.CANNOTCALCULATE )  .. var.deviceDefined )
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    -- Check and update rainRate and daily total Rain sensor (no looping to other stations as - is a valid response
                    local newRainTotal = 0
                    local rainmm = 0
                    if fn.handleGenericDevice(dev.rainRate,const.RAIN) then
                        -- prevent error on absence of numeric regenMMPU (rain per hour)
                        if tonumber(rt[i].regenMMPU) == nil then
                            rt[i].regenMMPU = 0
                        end
                        rainmm = rt[i].regenMMPU * 100
                        local rainAmountDuringInterval = fn.round((rt[i].regenMMPU * dev.rainRate.lastUpdate.secondsAgo / 3600),2)

                        -- Calc raintotal and reset raintotal during first run after midnight
                        if dev.rainRate.lastUpdate.secondsAgo <= now.secondsSinceMidnight then
                            newRainTotal = fn.round(rainAmountDuringInterval + dev.rainRate.rain,2)  -- No negativ rain allowed
                        else
                            newRainTotal = rainAmountDuringInterval
                            dev.rainRate.updateRain(rainmm,math.max(newRainTotal,0))                    -- ensure minimum of 1 update a day
                        end

                        if dev.rainRate.rain ~= newRainTotal or dev.rainRate.lastUpdate.minutesAgo > var.forcedUpdateMinutes then
                            dev.rainRate.updateRain(rainmm,math.max(newRainTotal,0))
                        else
                            dz.log(DBG.RAINRATESAME .. dev.rainRate.rain, dz.LOG_DEBUG)
                        end
                    end
                    fn.infoLog(fn.rightPad(fn.rightPad(INF.RAIN,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) .. rainmm  .. fn.wrapSpaces(INF.MMH,const.SWRAP) .. "," ..
                     fn.wrapSpaces(INF.RAINTOTAL).. math.max(newRainTotal,0) .. " mm") .. var.deviceDefined  )

                    -- Check and update Temperature / Humidity sensor
                    r = 0 ; i = BaseIndex;  var.processed = false ; var.stars = "" ; var.backupStation = ""
                    repeat
                        if tonumber(rt[i].temperatuurGC) ~= nil or r >= maxIndex then
                            var.processed = true
                            if fn.handleGenericDevice(dev.tempHumidity,const.TEMPHUMIDITY) then
                                if tonumber(rt[i].temperatuurGC) ~= nil then
                                   dev.tempHumidity.updateTempHum  (   rt[i].temperatuurGC,
                                                                   rt[i].luchtvochtigheid,
                                                                   fn.getHumidityStatus   (
                                                                                                tonumber(rt[i].temperatuurGC),
                                                                                                tonumber(rt[i].luchtvochtigheid) ) )
                                    fn.infoLog(fn.rightPad(fn.rightPad(fn.smartCase(INF.TEMPERATURE),const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW) .. rt[i].temperatuurGC .. fn.wrapSpaces(INF.CELSIUS,const.SWRAP)  ..
                                      "," .. fn.wrapSpaces(INF.HUMIDITY) .. rt[i].luchtvochtigheid  .. "% (" ..
                                                                    fn.getHumidityStatus   (
                                                                                                tonumber(rt[i].temperatuurGC),
                                                                                                tonumber(rt[i].luchtvochtigheid) , true )  .. ")" ))
                                    fn.infoLog(   fn.rightPad(fn.rightPad(fn.smartCase(INF.TEMPERATURE),const.LABELPOSITION) ..
                                                    fn.wrapSpaces(INF.ARROW) .. fn.wrapSpaces(INF.DEWPOINT,const.EWRAP) ..
                                                    fn.round(dev.tempHumidity.dewPoint,1) .. INF.CELSIUS ) .. var.deviceDefined)
                                else
                                    fn.infoLog(   fn.rightPad(fn.smartCase(INF.TEMPERATURE) .. fn.wrapSpaces(INF.ARROW) ..
                                    INF.NOMEASUREDVALUE )  .. var.deviceDefined )
                                end

                            else
                                if tonumber(rt[i].temperatuurGC) ~= nil then
                                    fn.infoLog(   fn.rightPad(fn.rightPad(fn.smartCase(INF.TEMPERATURE),const.LABELPOSITION) ..
                                                    fn.wrapSpaces(INF.ARROW) .. rt[i].temperatuurGC .. INF.CELSIUS .. "," ..
                                                    fn.wrapSpaces(INF.HUMIDITY) .. rt[i].luchtvochtigheid  .. "%") ..
                                                    var.deviceDefined .. var.backupStation)
                                else
                                    fn.infoLog(   fn.rightPad(fn.smartCase(INF.TEMPERATURE) .. fn.wrapSpaces(INF.ARROW) ..
                                                    INF.NOMEASUREDVALUE )  .. var.deviceDefined )
                                end
                            end
                        else
                            r = r + 1
                            var.stars = var.stars .. '*'
                            i = rt[BaseIndex].sortedNearbyIndex[r]
                            var.backupStation = " ==>> ".. var.stars .. " ==>> " .. rt[BaseIndex].sortedNearbyWeatherStation[r]
                            dz.log(var.backupStation,dz.LOG_DEBUG)
                        end
                    until var.processed

                    -- Check and update Short weather forecast
                    fn.handleTextDevice(   dev.weatherForecastShort,const.TEXT,rt[i].icoonactueel["@zin"],
                                        fn.rightPad(INF.WEATHERFORECASTPHRASE,const.LABELPOSITION) ..
                                        fn.wrapSpaces(INF.ARROW) .. fn.wrapSpaces(INF.SHORT,const.EWRAP))

                    -- Check and update Long weather forecast
                    fn.handleTextDevice(   dev.weatherForecastLong,const.TEXT,
                                        trigger.json.buienradarnl.weergegevens.verwachting_vandaag.samenvatting,
                                        fn.rightPad(INF.WEATHERFORECASTPHRASE,const.LABELPOSITION)..
                                        fn.wrapSpaces(INF.ARROW) .. INF.SUMMARY,true)

                    fn.infoLog(       "\n " .. trigger.json.buienradarnl.weergegevens.verwachting_vandaag.samenvatting ..
                                        fn.rightPad("\n ",const.LINELENGTH,"-"))

                    -- Check and update middle-long term weather forecast
                    var.myText =  trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_middellang["@periode"] .."\n " ..
                                    trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_middellang["#text"]
                    fn.handleTextDevice(dev.weatherForecastFiveDays,const.TEXT,var.myText,INF.NONE)
                    var.myText =  fn.rightPad('-',3,'-') ..
                                    fn.wrapSpaces(trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_middellang["@periode"]) ..
                                    fn.rightPad('-',3,'-') .."\n " ..
                                    trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_middellang["#text"]
                    fn.infoLog(fn.rightPad(fn.wrapSpaces(INF.FORECAST,const.EWRAP) .. INF.FIVEDAYS).. var.deviceDefined .. "\n " ..
                    fn.wrapSpaces( fn.wrapSpaces(var.myText),const.SWRAP,45) .. fn.rightPad("\n-",const.LINELENGTH,"-"))

                    -- Check and update Long weather forecast
                    var.myText =  trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_lang["@periode"] .."\n" ..
                                    trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_lang["#text"]
                    fn.handleTextDevice(dev.weatherForecastTwoWeeks,const.TEXT,var.myText,INF.NONE)
                    var.myText =  fn.rightPad('-',3,'-') ..
                                    fn.wrapSpaces(trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_lang["@periode"]) ..
                                    fn.rightPad('-',3,'-') .."\n " ..
                                    trigger.json.buienradarnl.weergegevens.verwachting_meerdaags.tekst_lang["#text"]
                    fn.infoLog(fn.rightPad(fn.wrapSpaces(INF.FORECAST,const.EWRAP) .. INF.TWOWEEKS).. var.deviceDefined .. "\n " ..
                    fn.wrapSpaces(var.myText,const.SWRAP,45) .. fn.rightPad("\n-",const.LINELENGTH,"-"))

                    ---
                    -- Now we can trigger the next openURL to get the rain forecast
                    ---
                    if tonumber(dz.data.domoticzLatitude) == 0 then
                        dz.log(ERR.LOCATIONNOTFOUND, dz.LOG_ERROR)
                        var.latitude = rt[i].latGraden or "51.86"              -- get latitude / longitude based on weatherstation location
                    else
                        var.latitude = dz.data.domoticzLatitude              -- get latitude / longitude based on weatherstation location
                    end

                    if tonumber(dz.data.domoticzLongitude) == 0 then
                        var.longitude = rt[i].lonGraden or "4.54"              -- get latitude / longitude based on weatherstation location
                    else
                        var.longitude = dz.data.domoticzLongitude              -- get latitude / longitude based on weatherstation location
                    end

                    local formatString = "%.2f"
                    const.RAINURL = const.RAINURL .. "?lat=" .. string.format(formatString,var.latitude) .. "&lon=" ..
                                                                string.format(formatString,var.longitude)
                    dz.log("const.RAINURL: " .. const.RAINURL ,dz.LOG_DEBUG)

                    if var.useTestSet then
                        dz.openURL({
                                    url = const.TESTURL ,
                                    method = "GET",
                                    callback = RAINRESPONSE })
                    else
                        dz.openURL({
                                    url = const.RAINURL,
                                    method = "GET",
                                    callback = RAINRESPONSE })
                    end
                    fn.infoLog(fn.rightPad('-',const.LINELENGTH,'-'))
                end
            end

            if not(var.found) then
                dz.log(ERR.WEATHERSTATIONPROBLEM .. myWeatherStation ..ERR.NOTFOUND, dz.LOG_ERROR)
            end
        else
            var.statusCode = TRIGGERERROR[trigger.statusCode] or trigger.statusCode
            dz.log(ERR.TRIGGERERROR .. " in:" .. const.TRIGGERNAME .. ", Error: "  .. var.statusCode , dz.LOG_ERROR)
        end

    elseif trigger.isTimer or trigger.isDevice then                        -- Script initial trigger. This will fire the first openURL
       dz.log(
                "\n\n" .. DBG.SHOULDITRIGGER .. " " .. const.LOCATIONURL .. " " .. DBG.NOW ..
                "\n" ..   DBG.SHOULDITRIGGER .. " " .. const.ADDRESSURL ..  " " .. DBG.NOW ..
                "\n" ..   fn.rightPad("var.useDomoticzLocation: ",35)        .. tostring(var.useDomoticzLocation) ..
                "\n" ..   fn.rightPad("dz.data.domoticzLatitude: ",35)   .. dz.data.domoticzLatitude ..
                "\n" ..   fn.rightPad("dz.data.domoticzLongitude: ",35)  .. dz.data.domoticzLongitude ..
                "\n" ..   fn.rightPad("now.hour: ",35)                   .. now.hour ..
                "\n" ..   fn.rightPad("now.minutes: ",35)                .. now.minutes .. "\n\n",                 dz.LOG_DEBUG )

        -- Get location from domoticz if requested in usersetting
        if var.useDomoticzLocation then
            if dz.data.domoticzLatitude == 0 or ( now.hour == 5 and now.minutes == 1 ) or var.forceWrite2Files then   -- Initial or refresh once a day
                dz.openURL({
                        url = const.LOCATIONURL,
                        method = "GET",
                        callback = LOCATIONRESPONSE })
            end
        end

         -- Get address from Google
        if var.useDomoticzLocation then
             if  ((dz.data.domoticzLatitude ~= 0 and dz.data.domoticzLongitude ~= 0  and dz.data.domoticzLocation == "Nederland" ) or
                  ( dz.data.domoticzLatitude ~= 0 and dz.data.domoticzLongitude ~= 0 and ( now.hour == 5 and now.minutes == 3 ))) or
                  var.forceWrite2Files then

                if not(var.useTestSet) then
                    const.ADDRESSURL = const.ADDRESSURL:gsub("latitude",dz.data.domoticzLatitude):gsub("longitude",dz.data.domoticzLongitude)
                    dz.openURL({
                                    url = const.ADDRESSURL,
                                    method = "GET",
                                    callback = ADDRESSRESPONSE  })
                else
                    dz.openURL({
                                    url = const.TESTURL,
                                    method = "GET",
                                    callback = ADDRESSRESPONSE })
                end
            end
        end

        if now.hour >= var.startDaytimeHour and now.hour < var.startNighttimeHour then
           frequency = var.daytimeFrequencyMinutes
        else
            frequency = var.nighttimeFrequencyMinutes
        end

        if tonumber(dz.data.minutesPastExecution) == 0 or tonumber(dz.data.minutesPastExecution) >= frequency   or trigger.isDevice then
            dz.data.minutesPastExecution = 1
        else
            dz.data.minutesPastExecution = dz.data.minutesPastExecution + 1
            dz.log("dz.data.minutesPastExecution: " .. tostring(dz.data.minutesPastExecution) .. fn.wrapSpaces(DBG.NOEXECUTION,const.SWRAP), dz.LOG_DEBUG)
            return                                                      -- Stop script execution
        end
        if not(var.useTestSet) then
            dz.openURL({
                url = const.WEATHERURL,
                method = "GET",
                callback = RADARRESPONSE })
        else
            dz.openURL({
                url = const.TESTURL,
                method = "GET",
                callback = RADARRESPONSE })
        end

    elseif const.TRIGGERNAME == RAINRESPONSE then                      -- This is the result of the second openURL (just data, no JSON)
        if trigger.ok then

            if var.forceWrite2Files then
                dz.log("Create datafile: " .. const.RAINDATA,dz.LOG_DEBUG)
                fn.writeTestData(trigger.data,const.RAINDATA)
            end

            local totalRain = 0
            local totalRainMM = 0
            local requestTime = 20

            const.ARROWPOSITION         = 24
            const.DEVICEPOSITION        = 50

            if var.useTestSet then
                -- Get the data from testFile and put it in trigger.data
                if fn.fileExists(const.RAINDATA) then
                    trigger.data = fn.getDataFromFile (const.RAINDATA)
                    var.testFileDate = fn.getFileDate (const.RAINDATA)
                    var.testSetWarning = fn.leftPad(fn.rightPad(fn.wrapSpaces(INF.TESTSETWARNING .. "(" .. var.testFileDate .. ")"),85,"*"),90,"*")
                else
                    local directory,separator =fn.getCurrentDir()

                    dz.log("directory " .. " ===>> " .. tostring(t), dz.LOG_ERROR)
                    dz.log("required datafile" .. "(" .. fn.getCurrentDir() ..
                            const.RAINDATA:gsub("%./",separator):gsub("%.\\",separator) ..
                            ")" .. " does not exist !!  "  .. " Script abort.",dz.LOG_ERROR)
                    return
                end
            else
                var.testSetWarning = ""
            end

            if trigger.data ~= nil then
                for value in trigger.data:gmatch("[^\r\n]+") do            -- Extract values only. We do not need the time
                    dz.log(string.sub(value,1,3),dz.LOG_DEBUG)
                    table.insert (rt,tonumber(string.sub(value,1,3))  )    -- Fill the table
                end
            end

            if rt[1] ~= nil then                                           -- Implicit check of the access to raintext API
                if var.useTestSet then
                    var.testSetWarning = fn.leftPad(fn.rightPad(fn.wrapSpaces(INF.TESTSETWARNING .. "(".. var.testFileDate .. ")"),85,"*"),90,"*")
                else
                    var.testSetWarning = ""
                end
                fn.infoLog (var.testSetWarning)

                fn.infoLog(fn.rightPad('-',const.LINELENGTH,'-'))

                -- Check and update rainAlarmAlert
                if fn.handleGenericDevice(dev.rainAlarm,const.ALARM) then
                    var.alertLevel = dz.ALERTLEVEL_GREEN
                    local rainLevel = fn.round(fn.RainForecast(rt, var.rainAlertTime),2)

                    if fn.round(rainLevel,1) > 0 or dev.rainAlarm.color ~=  dz.ALERTLEVEL_GREEN then
                        var.AlertText = fn.wrapSpaces(MUL.THEREWILLBE,const.EWRAP) .. rainLevel .. fn.wrapSpaces(MUL.MMRAIN) .. var.rainAlertTime .. fn.wrapSpaces(MUL.MINUTES)

                        if rainLevel < var.rainAlertAmount  then
                            var.alertLevel = dz.ALERTLEVEL_GREEN
                        elseif       rainLevel < 0.5  then var.alertLevel = dz.ALERTLEVEL_GREEN
                        elseif       rainLevel < 2.0  then var.alertLevel = dz.ALERTLEVEL_YELLOW
                        elseif       rainLevel < 4.0  then var.alertLevel = dz.ALERTLEVEL_ORANGE
                        else
                            var.alertLevel = dz.ALERTLEVEL_RED
                        end
                    else
                        var.AlertText  = (fn.wrapSpaces(MUL.NORAINEXPECTED,const.EWRAP) .. var.rainAlertTime .. fn.wrapSpaces(MUL.MINUTES,const.SWRAP))
                    end
                    if var.AlertText ~= dev.rainAlarm.text or dev.rainAlarm.lastUpdate.minutesAgo > var.forcedUpdateMinutes  then
                        dev.rainAlarm.updateAlertSensor(var.alertLevel, var.AlertText)
                    end

                    fn.infoLog(   fn.rightPad(fn.rightPad(fn.rightPad(fn.rightPad(INF.RAINALARM,const.LABELPOSITION) ..
                                    fn.wrapSpaces(INF.ARROW),const.ARROWPOSITION) .. fn.wrapSpaces(INF.ALERTLEVEL,const.EWRAP,1,1),
                                    const.INFOPOSITION) .. fn.wrapSpaces(INF.ARROW) .. fn.getAlertColor(var.alertLevel) ) .. var.deviceDefined)
                end

                -- Check and update dev.rainForecast_1_hour
                if fn.handleGenericDevice(dev.rainForecast_1_hour,const.CUST) then
                    if dev.rainForecast_1_hour.state == 0 and fn.round(RainForecast(rt, 60)) == 0 and
                            dev.rainForecast_1_hour.lastUpdate.minutesAgo < var.forcedUpdateMinutes then            -- Update after var.forcedUpdateMinutes anyway
                        dz.log(DBG.NORAINEXPEXTED1HOUR, dz.LOG_DEBUG)
                    else
                        dev.rainForecast_1_hour.updateCustomSensor(fn.round(fn.RainForecast(rt, 60),1))
                    end
                end
                fn.infoLog(   fn.rightPad(fn.rightPad(fn.rightPad(fn.rightPad(INF.RAINFORECAST,const.LABELPOSITION) ..
                                fn.wrapSpaces(INF.ARROW),const.ARROWPOSITION) .. fn.wrapSpaces(INF.NEXTHOUR,const.EWRAP,1,1),
                                const.INFOPOSITION) .. fn.wrapSpaces(INF.ARROW) .. fn.round(fn.RainForecast(rt, 60),1) ..
                                fn.wrapSpaces(INF.MMH)) .. var.deviceDefined)

                -- Check and update rainForecast-2_hours
                if fn.handleGenericDevice(dev.rainForecast_2_hours,const.CUST) then
                    if dev.rainForecast_2_hours.state == 0 and fn.round(fn.RainForecast(rt, 120)) == 0 and
                            dev.rainForecast_2_hours.lastUpdate.minutesAgo < var.forcedUpdateMinutes then
                        dz.log(DBG.NORAINEXPEXTED2HOURS, dz.LOG_DEBUG)
                    else
                        dev.rainForecast_2_hours.updateCustomSensor(fn.round(fn.RainForecast(rt, 120),2))
                    end
                end
                fn.infoLog(   fn.rightPad(fn.rightPad(fn.rightPad(fn.rightPad(INF.RAINFORECAST,const.LABELPOSITION) ..
                                fn.wrapSpaces(INF.ARROW),const.ARROWPOSITION) .. fn.wrapSpaces(INF.NEXT2HOURS,const.EWRAP,1,1),
                                const.INFOPOSITION) .. fn.wrapSpaces(INF.ARROW).. fn.round(fn.RainForecast(rt, 120),1) ..
                                fn.wrapSpaces(INF.MMH)) .. var.deviceDefined)

                -- Check and update rainAlarmSwitch
                if fn.handleGenericDevice(dev.rainAlarmSwitch,const.SWITCH) then
                local newState = "Off"

                    if tonumber(fn.RainForecast(rt, 120)) > tonumber(var.rainAlertAmount) then
                       if dev.rainAlarmSwitch.lastUpdate.minutesAgo > var.forcedUpdateMinutes  then
                            dev.rainAlarmSwitch.switchOn()
                       else
                            dev.rainAlarmSwitch.switchOn().checkFirst()
                       end
                       newState = "On"
                    else
                       if dev.rainAlarmSwitch.lastUpdate.minutesAgo > var.forcedUpdateMinutes  then
                           dev.rainAlarmSwitch.switchOff()
                       else
                            -- dev.rainAlarmSwitch.switchOff()
                            dev.rainAlarmSwitch.switchOff().checkFirst()
                       end

                    end
                    fn.infoLog(   fn.rightPad(fn.rightPad(fn.rightPad(fn.rightPad(INF.RAINALARM,
                                    const.LABELPOSITION) ..   fn.wrapSpaces(INF.ARROW),const.ARROWPOSITION) ..
                                    fn.wrapSpaces(INF.SWITCH,const.EWRAP,1,1),const.INFOPOSITION) ..
                                    fn.wrapSpaces(INF.ARROW) .. newState) .. var.deviceDefined)
                end

                -- Check and update rainAlarmText
                if fn.handleGenericDevice(dev.rainAlarmText,const.TEXT) then
                    var.rainAlertTime = math.min(var.rainAlertTime,120)
                    local infoText = MUL.NORAINEXPECTED .. var.rainAlertTime .. MUL.MINUTES
                    if fn.round(fn.RainForecast(rt, var.rainAlertTime)) > 0 then
                        infoText = fn.wrapSpaces(MUL.THEREWILLBE,const.EWRAP) .. fn.round(fn.RainForecast(rt, var.rainAlertTime),2) ..
                        fn.wrapSpaces(MUL.MMRAIN,const.SWRAP) .. var.rainAlertTime .. MUL.MINUTES
                        dev.rainAlarmText.updateText(infoText)
                    elseif dev.rainAlarmText.text ~= fn.wrapSpaces(MUL.NORAINEXPECTED,const.EWRAP) .. var.rainAlertTime .. fn.wrapSpaces(MUL.MINUTES,const.SWRAP) or
                        dev.rainAlarmText.lastUpdate.minutesAgo > var.forcedUpdateMinutes then
                        dev.rainAlarmText.updateText(infoText)
                    end
                    fn.infoLog(fn.rightPad(fn.rightPad(fn.rightPad(INF.RAINALERT,const.LABELPOSITION) .. fn.wrapSpaces(INF.ARROW),const.ARROWPOSITION)  .. infoText) .. var.deviceDefined)
                end
                fn.infoLog(fn.rightPad('-',const.LINELENGTH,'-'))
                if var.devicesDefined == 0 then
                  fn.infoLog(INF.NODEVICESDEFINED)
                end
            else
              dz.log(ERR.CONVERSIONPROBLEM , dz.LOG_ERROR)
            end
        else
            if TRIGGERERROR ~= nil then
                var.statusCode = TRIGGERERROR[trigger.statusCode] or trigger.statusCode or "unknown"
            else
                var.statusCode = trigger.statusCode or "unknown"
            end
            dz.log(ERR.TRIGGERERROR .. " in:" .. const.TRIGGERNAME .. ", Error: "  .. var.statusCode , dz.LOG_ERROR)
        end
    elseif const.TRIGGERNAME == LOCATIONRESPONSE then                   -- This is the result of the third openURL (get domoticz lat,lon
        if trigger.ok then

            if var.forceWrite2Files then
                dz.log("Create datafile: " .. const.LOCATIONDATA,dz.LOG_DEBUG)
                fn.writeTestData(dz.utils.toJSON(trigger.json),const.LOCATIONDATA)
            end

            if var.useTestSet then

                if fn.fileExists(const.LOCATIONDATA) then
                    -- Get the json from testFile and put it in the resultTable table
                    trigger.json= dz.utils.fromJSON(fn.getDataFromFile (const.LOCATIONDATA))
                    var.testFileDate = fn.getFileDate (const.LOCATIONDATA)
                else
                    local directory,separator =fn.getCurrentDir()

                    dz.log("directory " .. " ===>> " .. tostring(t), dz.LOG_ERROR)
                    dz.log("required datafile" .. "(" .. fn.getCurrentDir() ..
                            const.LOCATIONDATA:gsub("%./",separator):gsub("%.\\",separator) ..
                            ")" .. " does not exist !!  "  .. " Script abort.",dz.LOG_ERROR)
                    return

                end
            else
                var.testSetWarning = ""
            end

    --end

            -- Fill vars
            if trigger.json.Location ~= nil then
                if trigger.json.Location.Latitude ~= nil then
                    dz.data.domoticzLatitude = trigger.json.Location.Latitude
                    dz.log(trigger.json.Location.Latitude , dz.LOG_DEBUG)
                    if trigger.json.Location.Longitude ~= nil then
                        dz.data.domoticzLongitude = trigger.json.Location.Longitude
                        dz.data.locationUpdated = now.rawDate .. " " .. now.rawTime
                        dz.log(trigger.json.Location.Latitude , dz.LOG_DEBUG)

                    end
                else
                       dz.log(ERR.LOCATIONNOTFOUND, dz.LOG_DEBUG)
                end
            else
                      dz.log(ERR.LOCATIONNOTFOUND, dz.LOG_DEBUG)
            end
        else
            var.statusCode = TRIGGERERROR[trigger.statusCode] or trigger.statusCode
            dz.log(ERR.TRIGGERERROR .. " in:" .. const.TRIGGERNAME .. ", Error: "  .. var.statusCode , dz.LOG_ERROR)
        end
    elseif const.TRIGGERNAME == ADDRESSRESPONSE then                    -- This is the result of the fourth openURL (get ADDRESS)
        if trigger.ok then

            if var.forceWrite2Files then
                dz.log("Create datafile: " .. const.ADDRESSDATA,dz.LOG_DEBUG)
                fn.writeTestData(dz.utils.toJSON(trigger.json),const.ADDRESSDATA)
            end

            if var.useTestSet then
                -- Get the json from testFile and put it in the resultTable table
                if fn.fileExists(const.ADDRESSDATA) then
                    trigger.json= dz.utils.fromJSON(fn.getDataFromFile (const.ADDRESSDATA))
                    var.testFileDate = fn.getFileDate (const.ADDRESSDATA)
                else
                    local directory,separator =fn.getCurrentDir()
                    dz.log("directory " .. " ===>> " .. tostring(t), dz.LOG_ERROR)
                    dz.log("required datafile" .. "(" .. fn.getCurrentDir() ..
                            const.ADDRESSDATA:gsub("%./",separator):gsub("%.\\",separator) ..
                            ")" .. " does not exist !!  "  .. " Script abort.",dz.LOG_ERROR)
                    return
                end
            end

            -- Fill vars
            if trigger.json ~= nil then
                if trigger.json.results ~= nil then
                    if trigger.json.results[1].formatted_address ~= nil then
                        local myResultString = trigger.json.results[1].formatted_address
                        myResultString = myResultString:gsub("Netherlands","Nederland")
                        dz.log (myResultString,dz.LOG_INFO)
                        dz.data.domoticzLocation = myResultString
                        dz.data.locationUpdated = now.rawDate .. " " .. now.rawTime
                    else
                        dz.log(ERR.ADRESSNOTFOUND, dz.LOG_DEBUG)
                    end
                else
                    dz.log(ERR.ADRESSNOTFOUND, dz.LOG_DEBUG)
                end
            else
                   dz.log(ERR.ADDRESSNOTFOUND, dz.LOG_DEBUG)
            end
        else
            var.statusCode = TRIGGERERROR[trigger.statusCode] or trigger.statusCode
            dz.log(ERR.TRIGGERERROR .. " in:" .. const.TRIGGERNAME .. ", Error: "  .. var.statusCode , dz.LOG_ERROR)
        end
    else
        dz.log(ERR.UNKNOWNEVENT, dz.LOG_ERROR)
    end
end
}