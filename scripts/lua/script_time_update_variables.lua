----------------------------------------------------------------------------------------------------------
-- Script parameters
----------------------------------------------------------------------------------------------------------
Debug = "NO"                    -- Turn debugging on ("YES") or off ("NO")
 
----------------------------------------------------------------------------------------------------------
-- Script functions
----------------------------------------------------------------------------------------------------------
function WhichSeason()
     local tNow = os.date("*t")
     local dayofyear = tNow.yday
     local season
     if (dayofyear >= 79) and (dayofyear < 172) then season = "Spring"
     elseif (dayofyear >= 172) and (dayofyear < 266) then season = "Summer"
     elseif (dayofyear >= 266) and (dayofyear < 355) then season = "Autumn"
     else season = "Winter"
     end
     return season
end
 
function IsWeekend()
     local dayNow = tonumber(os.date("%w"))
     local weekend
     if (dayNow == 0) or (dayNow == 6) then weekend = "True"
     else weekend = "False"
     end 
     return weekend
end
 
 
function IsDark()
    local dark
    if (timeofday['Nighttime']) then dark = "True"
    else dark = "False"
    end
    return dark
end
 
 
----------------------------------------------------------------------------------------------------------
-- CommandArray
----------------------------------------------------------------------------------------------------------
 
commandArray = {}
 
-- 		Setting the time variables:
--		%a	abbreviated weekday name (e.g., Wed)
--		%A	full weekday name (e.g., Wednesday)
--		%b	abbreviated month name (e.g., Sep)
--		%B	full month name (e.g., September)
--		%c	date and time (e.g., 09/16/98 23:48:10)
--		%d	day of the month (16) [01-31]
--		%H	hour, using a 24-hour clock (23) [00-23]
--		%I	hour, using a 12-hour clock (11) [01-12]
--		%M	minute (48) [00-59]
--		%m	month (09) [01-12]
--		%p	either "am" or "pm" (pm)
--		%S	second (10) [00-61]
--		%w	weekday (3) [0-6 = Sunday-Saturday]
--		%x	date (e.g., 09/16/98)
--		%X	time (e.g., 23:48:10)
--		%Y	full year (1998)
--		%y	two-digit year (98) [00-99]
--		%%	the character `%´
 
year 	= tonumber(os.date("%Y"));
month 	= tonumber(os.date("%m"));
day 	= tonumber(os.date("%d"));
hour 	= tonumber(os.date("%H"));
min 	= tonumber(os.date("%M"));
weekday = tonumber(os.date("%w"));
season  = WhichSeason();
weekend = IsWeekend();
dark    = IsDark();
 
if Debug=="YES" then
	print(' Year: '  .. year .. ' ');
	print(' Month: '  .. month .. ' ');
	print(' Day: '  .. day .. ' ');
	print(' Hour: '  .. hour .. ' ');
	print(' Minute: '  .. min .. ' ');
	print(' Weekday: '  .. weekday .. ' ');
	print(' Season: ' .. season .. ' ');
	print(' Weekend: ' .. weekend .. ' ');
        print(' Dark: ' .. dark .. ' ');
	end
 
print("Updating variables if necessary")
 
if (uservariables["Year"] ~= year) then commandArray['Variable:Year'] = tostring(year)   end
if (uservariables["Month"] ~= month) then commandArray['Variable:Month'] = tostring(month)   end
if (uservariables["Day"] ~= day) then commandArray['Variable:Day'] = tostring(day)   end
if (uservariables["Hour"] ~= hour) then commandArray['Variable:Hour'] = tostring(hour)   end
if (uservariables["Minute"] ~= min) then commandArray['Variable:Minute'] = tostring(min)   end
if (uservariables["Weekday"] ~= weekday) then commandArray['Variable:Weekday'] = tostring(weekday)   end
if (uservariables["Season"] ~= season) then commandArray['Variable:Season'] = tostring(season)   end
if (uservariables["Weekend"] ~= weekend) then commandArray['Variable:Weekend'] = tostring(weekend)   end
if (uservariables["Dark"] ~= dark) then commandArray['Variable:Dark'] = tostring(dark)   end
 
 
return commandArray