pin = 4 --data pin, GPIO2

--funzt nur mit build-in dht modul und float-version
function ReadDHT()
    status,temp,humi,temp_decimial,humi_decimial = dht.read(pin)
    if( status == dht.OK ) then
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    elseif( status == dht.ERROR_CHECKSUM ) then
        print( "DHT Checksum error." );
    elseif( status == dht.ERROR_TIMEOUT ) then
    print( "DHT Time out." );
    end
end    

ReadDHT()

tmr.alarm(1,1000*60*1,1,function()ReadDHT()end)
