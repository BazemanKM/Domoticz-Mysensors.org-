commandArray = {}
 
tc=next(devicechanged)
v=tostring(tc)
if (v:sub(1,3) == 'PIR') then
    c=v:sub(4)
    commandArray[c] = 'On'
    tmess = c..' On - time 0'
    print(tmess)
end
 
return commandArray