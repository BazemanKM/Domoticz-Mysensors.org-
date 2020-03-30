-- /home/pi/domoticz/scripts/lua/script_device_calculate_consumption.lua
-- This script collects the values below from Domoticz
--   * The Power and energy values (import and export) from a smartmeter 
--   * The Power and energy values from a Solar power inverter
-- It then calculates the consumed power and energy from the values above with the formula's
--   * EnergyConsumption = EnergyGeneration + EnergyImport - EnergyExport
--   * PowerConsumption = PowerGeneration + PowerImport - PowerExport
-- It then updates a virtual device which displays the consumed power and energy in Domoticz

----------------------------------------------------------------------------------------------------------
-- Domoticz IDX and names of the needed devices
----------------------------------------------------------------------------------------------------------
local GenerationDeviceName = "Opgewekt PVOutput" 		-- Device name of the Generated energy
local EnergyDeviceName = "Stroommeter"
local ConsumptionIDX = 5559  			-- IDX of the energy device that shows calculated Consumption
local ConsumptionDeviceName = "Berekenen Verbruik" 		-- Name of the energy device that shows calculated Consumption

----------------------------------------------------------------------------------------------------------
-- Require parameters
----------------------------------------------------------------------------------------------------------
local http = require("socket.http")

----------------------------------------------------------------------------------------------------------
-- Script parameters
----------------------------------------------------------------------------------------------------------
EnergyImportLow = 0	-- in Watt hours
EnergyImportHigh = 0	-- in Watt hours
EnergyExportLow = 0	-- in Watt hours
EnergyExportHigh = 0	-- in Watt hours
EnergyGeneration = 0 	-- in Watt hours
PowerGeneration = 0 	-- in Watts
EnergyImport = 0	-- in Watt hours
PowerImport = 0		-- in Watts
EnergyConsumption = 0 	-- in Watt hours
PowerConsumption = 0 	-- in Watts
Debug = "YES" 		-- Turn debugging on ("YES") or off ("NO")

----------------------------------------------------------------------------------------------------------
-- Lua Functions
----------------------------------------------------------------------------------------------------------
function update(device, id, power, energy, index)
	commandArray[index] = {['UpdateDevice'] = id .. "|0|" .. power .. ";" .. energy}
end 

----------------------------------------------------------------------------------------------------------
-- CommandArray
----------------------------------------------------------------------------------------------------------
commandArray = {}
	-- Generated
	PowerGeneration, EnergyGeneration = otherdevices_svalues[GenerationDeviceName]:match("([^;]+);([^;]+)")
	if Debug=="YES" then
		print("  ----- PowerGeneration = " .. PowerGeneration .. " W");

	end

	EnergyImportLow, EnergyImportHigh, EnergyExportLow, EnergyExportHigh, PowerImport, PowerExport = otherdevices_svalues[EnergyDeviceName]:match("([^;]+);([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
	EnergyImport = EnergyImportLow + EnergyImportHigh
	EnergyExport = EnergyExportLow + EnergyExportHigh
	if Debug=="YES" then
		print("  ----- PowerImport = " .. PowerImport .. " W");
		print("  ----- PowerExport = " .. PowerExport .. " W");

	end

	-- Calculate consumption
	if PowerGeneration=="nan" then 
	PowerConsumption = PowerImport - PowerExport

	else	
	PowerConsumption = PowerGeneration + PowerImport - PowerExport
	end

	if Debug=="YES" then
		print("  ----- PowerConsumption = " .. PowerConsumption .. " W");
	end

	-- Update comsumption device in Domoticz
	if devicechanged[EnergyDeviceName] then
		update(ConsumptionDeviceName, ConsumptionIDX, PowerConsumption, EnergyConsumption, 1)
	end
	
return commandArray