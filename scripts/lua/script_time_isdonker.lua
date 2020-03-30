--[[

	script_time_isdonker.lua
	@author: Nicky Bulthuis
	@since: 2015-01-24
	@version: 0.1

	Al enige tijd heb ik de wens om mijn verlichting in de woonkamer te kunnen schakelen middels een schermer sensor. Ik gebruik hiervoor een 
	Kaku ABST-604 schemer sensor, maar elke schemer sensor zou moeten werken (denk ik). Ik wil het volgende bereiken:
	
	* Schakelen zodra het donker wordt en als het weer licht wordt.
	* Schakelen bij bewolking.
	* Niet schakelen bij wat overwaaiende wolken.
	
	Het schakelen op lichtsterkte kan door de ABST-604 instellen op 0 uren. De schemer sensor zal dan aan en uit schakelen op het ingestelde
	schemer niveau. Het probleem is vervolgens dat het vaak aan/uit zal schakelen zodra de ingestelde lichtsterkte bereikt wordt. Iets wat ik
	een flipstorm noem. Dit script probeert zo goed mogelijk om dat probleem heen te werken. 
	
	Het resultaat van die script is een Virtuele Switch genaaamd 'State - IsDonker' (of de door jou gekozen naam) welke aan de hand van wat
	instellingen de Schemer Sensor status gaat volgen. Je zult echter zien dat de 'State - IsDonker' schakelaar veel rustiger is dan de
	schemer sensor waardoor hij goed te gebruiken is voor bijvoorbeeld verlichting in de Woonkamer. 
	
	Benodigdheden:
	
	* Een Schemer Sensor, bijvoorbeeld de Kaku ABST-604. Vul hiervan de naam in bij 'schemersensor'.
	* Een 'State - IsDonker' virtuele switch. Vul hiervan de naam in bij 'isdonker'.
	* Een 'IsDonker - Flipstorm' User Variabele. Vul hiervan de naam in bij 'flipstorm'.
	* Dit script, plaats deze in <DOMOTICZ>/scripts/lua/script_time_isdonker.lua
	
	Vervolgens kun je de 'State - IsDonker' switch gebruiken in andere Lua scripts of Blocky Events. 
	
	De standaard instellingen zijn 3 minuten voor On en 5 minuten voor Off. Deze waarden zijn aan te passen door de variabelen flipstorm_on
	en flipstorm_off aan te passen. In andere woorden:
	
	* elke minuut wordt het script aangeroepen (de minimale tijd mogelijk in Domoticz)
	* bij 3 maal een On gezien te hebben, schakelt de 'State - IsDonker' switch naar on.
	* bij 5 maal een Off gezien te hebben, schakelt de 'State - IsDonker' switch naar off. 
	
	Een overwaaiende wolk heeft dus 3 minuten de tijd om voorbij de schemersensor te waaien.

--]]

-- **********************************
-- Settings
-- **********************************

-- Logging: 0 = Geen, 1 = Beetje, 2 = Alles
local verbose = 2 	

-- De naam van de schemer sensor.
local schemersensor = 'Schemersensor' 

-- De naam van de isDonker virtuele switch.
local isdonker = 'Lichtsensor'

--
-- Flipstorming en het detecteren van wolken.
--
-- Detecteren of het donker is buiten kan een zogenaamd flipstorm veroorzaken. Zo noem ik het snel aan, uit en weer aangaan van een 
-- device. Het komt het meest voor wanneer de hoeveelheid licht buiten het niveau bereikt waarop de schemer sensor staat ingesteld. 
-- Je zult dan zien dat de schemer sensor meerdere keer aan en uit zal schakelen. Omdat we niet willen dat bijvoorbeeld de verlichting
-- ook aan en uit schakeld zullen we moeten controleren of we in een flipstorm zitten. 
--
-- Een andere probleem is de aanwezigheid van wolking. Doordat een work het licht van de zon blokeert zal de schemer sensor aan schakelen. 
-- Echter, hoeft de verlichting echt niet aan voor een enkele wolk, deze zal immers na korte tijd weer verdwenen zijn. Het voorbij waaien
-- van een wolk kan ook een flipstorm veroorzaken. 
--
-- We kunnen hierom heen werken door bij te houden hoevaak we aan, dan wel uit switchen. We doen dit door een User Variabele bij te houden
-- van het type integer. Elke keer als we On zien tellen we er één bij op, als we na 'x' aantal keren On nog steeds geen Off gezien hebben
-- gaan we er vanuit dat het geen flipstorm betreft. Het zelfde geld uiteraar voor het uitschakelen. 
--

-- De naam van de User Variable voor het tellen van de flipstorm, type integer, zet hem op 0.
local flipstorm = 'IsDonker - Flipstorm'

-- Het aantal minuten/keer dat we de schemer sensor op On willen zien voordat we de IsDonker switch op On zetten.		
local flipstorm_on = 3

-- Het aantal minuten/keer dat we de schemer sensor op Off willen zien voordat we de IsDonker switch op Off zetten.		
local flipstorm_off = 3

--
-- Een voorbeeld: 
-- Laten we van bovenstaande instellingen uitgaan. Het is 14:00, twee wolken komen overwaaien:
-- 14:00 -> IsDonker = Off
-- 14:01 -> IsDonker = Off => De eerste wolk blokkeerd de schemer sensor en springt dus op On. IsDonker - Flipstorm -> 0 - 1. 
-- 14:02 -> IsDonker = Off => De eerste wolk is voorbij, maar de tweede blokkeerd nu onze sensor. IsDonker - Flipstorm -> 1 - 2.
-- 14:03 -> IsDonker = Off => De tweede wolk is voorbij en de schemer sensor springt weer op Off. IsDonker - Flipstorm -> reset naar 0.
-- 14:04 -> IsDonker = Off => De wolken zijn dus voorbij, het maakte totaal niet uit hoevaak de schemer sensor op on/off ging. IsDonker is niet veranderd.

-- Tweede voorbeeld:
-- Wederom bovenstaande instellingen, maar nu komt er een flink bewolking aan:
-- 14:00 -> IsDonker = Off
-- 14:01 -> IsDonker = Off => Het stormfront blokkeerd onze sensor. IsDonker - Flipstorm -> 0 - 1. 
-- 14:02 -> IsDonker = Off => Het stormfront blokkeerd nog steeds onze sensor. IsDonker - Flipstorm -> 1 - 2. 
-- 14:03 -> IsDonker = Off => Het stormfront blokkeerd nog steeds onze sensor. IsDonker - Flipstorm -> 2 - 3.
-- 14:04 -> IsDonker = On => Het stormfront blokeerd nog steeds de sensor, dus waarschijnlijk geen flipstorm/wolk. IsDonker - Flipstorm -> blijft op 3.
-- 14:05 -> IsDonker = On => IsDonker is naar On geschakeld en kan nu gebruikt worden om bijvoorbeeld verlichting aan te zetten.
--
-- Andersom werkt het natuurlijk precies hetzelfde. 

-- **************************************************************************************************************************************************
-- **************************************************************************************************************************************************
--
-- Main script. You (as a user) should not modify anything beyond this point. However if you do, repair a bug, add an enhancement. Please share it so
-- all will benefit from it.
--
-- **************************************************************************************************************************************************
-- **************************************************************************************************************************************************

--
-- Debug logging.
--
function debug(msg)

	if verbose >= 2 then
		print('IsDonker[DEBUG] ==> ' .. msg)
	end

end

--
-- Info logging.
--
function info(msg)

	if verbose >= 1 then
		print('IsDonker[INFO] ==> ' .. msg)
	end

end

--
-- Error logging.
--
function error(msg)

	print('IsDonker[ERROR] ==> ' .. msg)

end

--
-- Validates the configuration
--
function validate() 

	result = true

	if not uservariables[flipstorm] then
		error('User Variable [' .. flipstorm .. '] bestaat niet.')
		result = false
	end
	
	if not otherdevices[isdonker] then
		error('Device [' .. isdonker .. '] bestaat niet.')
		result = false
	end
	
	if not otherdevices[schemersensor] then
		error('Device [' .. schemersensor .. '] bestaat niet.')
		result = false
	end 


	return result

end

--
-- Tests of de IsDonker mag veranderen.
--
function may_update(is_donker)

	counter = tonumber(uservariables[flipstorm])
	current_counter = counter
	
	-- set the counter.
	if is_donker and counter >= 0 then
		counter = math.min(flipstorm_on, counter + 1)
	elseif not is_donker and counter <= 0 then
		counter = math.max(flipstorm_off * -1, counter - 1)
	else
		counter = 0
	end

	if counter ~= current_counter then
		commandArray['Variable:' .. flipstorm]=tostring(counter)
	end

	result = false
		
	if is_donker and counter >= flipstorm_on then
		result = true
	elseif not is_donker and math.abs(counter) >= flipstorm_off then
		result = true
	end

	debug('UserVar=[' .. flipstorm .. '] Counter=[' .. counter .. '] MayUpdate=[' .. tostring(result) .. ']')
	
	return result

end

--
-- Aanpassen status van IsDonker. .
--
function on_off(is_donker)

	update_allowed = may_update(is_donker)

	info('OnOff State[' .. otherdevices[isdonker] .. '] UpdateAllowed[' .. tostring(update_allowed) ..'] IsDark[' .. tostring(is_donker) .. ']')

	if update_allowed then
		if otherdevices[isdonker] == 'Off' and is_donker then
 			commandArray[isdonker]='On'
		elseif (otherdevices[isdonker] == 'On' and not is_donker) then
 			commandArray[isdonker]='Off'
		end
	end

end

--
-- Is de Schemer Sensor On.
--
function is_schemersensor_aan()

	result = false
	result = otherdevices[schemersensor] == 'On'
    debug('SchemerSensor Current[' .. otherdevices[schemersensor] .. '] = ' .. tostring(result))
    return result
end

commandArray = {}

if validate() then
	on_off(is_schemersensor_aan())
end
return commandArray