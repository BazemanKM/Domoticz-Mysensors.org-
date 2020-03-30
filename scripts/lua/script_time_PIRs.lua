function timedifference(s)
   year = string.sub(s, 1, 4)
   month = string.sub(s, 6, 7)
   day = string.sub(s, 9, 10)
   hour = string.sub(s, 12, 13)
   minutes = string.sub(s, 15, 16)
   seconds = string.sub(s, 18, 19)
   t1 = os.time()
   t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
   difference = os.difftime (t1, t2)
   return difference
end
 
commandArray = {}
 
for i, v in pairs(otherdevices) do
   timeon = 240
   tc = tostring(i)
   v = i:sub(1,3)
   if (v == 'PIR') then
      difference = timedifference(otherdevices_lastupdate[tc])
      if (difference > timeon and difference < (timeon + 60)) then
         tempdiff = tostring(difference)
         c = i:sub(4)
         tempmessage = c.." Light Off - after at least " .. (timeon+1) .. "secs up - actually - " .. tempdiff .. "seconds"
         print(tempmessage)
         commandArray[c] = 'Off'
      end
   end
end
 
return commandArray