-- /home/pi/domoticz/scripts/lua/script_time_upload_to_PVoutput.lua
-- This script collects the values below from Domoticz
--   * The Power generation, energy generation and voltage from a Solar power inverter
--   * The temperature from a outside temperature sensor
--   * The Power consumption and energy consumption which is calculated in another Lua script 
-- And uploads all of the values to a PVoutput account.
--
-- For more information about PVoutput, see their user documentation on http://www.pvoutput.org/help.html

----------------------------------------------------------------------------------------------------------
-- Domoticz IDX of devices
----------------------------------------------------------------------------------------------------------
local ConsumptionDeviceName = "Berekenen Verbruik" 	-- Name of the energy device that shows calculated Consumption
local TemperatureDeviceName = "Buitentemperatuur" 	-- Name of the temperature device that shows outside temperature
local TemperatureDeviceName2 = "Zonnepanelen"
local SolarDeviceName= "Buienradar zonnestraling"

----------------------------------------------------------------------------------------------------------
-- PVoutput parameters
----------------------------------------------------------------------------------------------------------
local PVoutputApi = "XXXXXXX" 				-- Your PVoutput api key
local PVoutputSystemID = "XXXXX" 					-- Your PVoutput System ID
local PVoutputPostInterval = 1 						-- The number of minutes between posts to PVoutput (normal is 5 but when in donation mode it's max 1)
local PVoutputURL = '://pvoutput.org/service/r2/addstatus.jsp?key='	-- The URL to the PVoutput Service

----------------------------------------------------------------------------------------------------------
-- Require parameters
----------------------------------------------------------------------------------------------------------
local http = require("socket.http")

----------------------------------------------------------------------------------------------------------
-- Script parameters
----------------------------------------------------------------------------------------------------------
EnergyGeneration = 0 	-- v1 in Watt hours
PowerGeneration = 0 	-- v2 in Watts
EnergyConsumption = 0 	-- v3 in Watt hours
PowerConsumption = 0 	-- v4 in Watts
CurrentTemp = 0 	-- v7 in celcius
CurrentTemp2 = 0 	-- v8 in celcius
Voltage = 0 		-- v6 in volts
c1 = 1 			-- c1 = 0 when v1 is today's energy. c1 = 1 when v1 is lifetime energy.
Debug = "YES" 		-- Turn debugging on ("YES") or off ("NO")

----------------------------------------------------------------------------------------------------------
-- Lua Functions
----------------------------------------------------------------------------------------------------------
function UploadToPVoutput(self)
	b, c, h = http.request("http" .. PVoutputURL .. PVoutputApi .. "&sid=".. PVoutputSystemID .. "&d=" .. os.date("%Y%m%d") .. "&t=" .. os.date("%H:%M") .. 

	"&v4=" .. PowerConsumption .. "&v7=" .. CurrentTemp .. "&v8=" .. CurrentTemp2 .. "&v9=" .. Solar .. "&c1=" .. c1 )
	if b=="OK 200: Added Status" then
		print(" -- Current status successfully uploaded to PVoutput.")
	else
		print(" -- " ..b)
	end
	
	print(" -- Power consumption (v4) = " .. PowerConsumption .. " W")
	print(" -- Current temperature (v7) = " .. CurrentTemp .. " C")
	print(" -- Current temperature (v8) = " .. CurrentTemp2 .. " C")
	print(" -- Solar Radiation (v9) = " .. Solar .. " W/m2")
	print(" -- Cumulative Flag (c1) = " .. c1 .. "")
end

function update(device, id, power, energy, index)
	commandArray[index] = {['UpdateDevice'] = id .. "|0|" .. power .. ";" .. energy}
end 

----------------------------------------------------------------------------------------------------------
-- CommandArray
----------------------------------------------------------------------------------------------------------
commandArray = {}

	time = os.date("*t")
	if PVoutputPostInterval>1 then
		TimeToGo = PVoutputPostInterval - (time.min % PVoutputPostInterval)
		print('Time to go before upload to PVoutput: ' ..TimeToGo.. " minutes")
	end
	
	if((time.min % PVoutputPostInterval)==0)then
		
		-- Temperature
		CurrentTemp = otherdevices_svalues[TemperatureDeviceName]:match("([^;]+)")
		if Debug=="YES" then
			print(" ---- The outside temperature is " .. CurrentTemp .. " C.");
		end

		-- Temperature2
		CurrentTemp2 = otherdevices_svalues[TemperatureDeviceName2]:match("([^;]+)")
		if Debug=="YES" then
			print(" ---- The outside temperature is " .. CurrentTemp2 .. " C.");
		end
		
		-- Consumption
		PowerConsumption, EnergyConsumption = otherdevices_svalues[ConsumptionDeviceName]:match("([^;]+);([^;]+)")
		if Debug=="YES" then
			print(" ---- The current consumed power is " .. PowerConsumption .. " W");
		end

		-- Solar
		Solar = otherdevices_svalues[SolarDeviceName]:match("([^;]+)")
		if Debug=="YES" then
			print(" ---- Solar Radiation is " .. Solar .. " W/m2.");
		end

		-- Upload data to PVoutput	
		UploadToPVoutput()
	end

return commandArray
