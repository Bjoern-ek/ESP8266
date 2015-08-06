function init_OLED(sda, scl)
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
     disp:setFont(u8g.font_6x10)
     disp:setFontRefHeightExtendedText()
     disp:setDefaultForegroundColor()
     disp:setFontPosTop()
end

Text1 = " DHT22 to SSD1306"

init_OLED(5,6) --ESP8266-12
--init_OLED(3,4) --ESP8266-1

function u8g_test()

    disp:firstPage()
    repeat
        disp:drawRFrame(0, 0, 128, 16, 3)   -- ein Rahmen mit runden ecken
        disp:drawStr(2, 3, Text1)           -- text aus einer variablen
        disp:drawStr(2, 16, "Temperatur : "..temp.." C")
        disp:drawStr(2, 28, "Luftfeuchte: "..humi.." %")
        disp:drawBox(40,40, math.floor(temp), 8)        -- die Temperatur als Balken
        disp:drawStr(40,48, "0")                        -- eine 0 als anfang
        disp:drawStr(math.floor(temp)+42, 40, temp.."C")
    until disp:nextPage() == false
    
end

pin = 4 --data pin, GPIO2

--funzt nur mit build-in dht modul und float-version
function ReadDHT()
    status,temp,humi,temp_decimial,humi_decimial = dht.read(pin)
    if( status == dht.OK ) then
    --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    
    elseif( status == dht.ERROR_CHECKSUM ) then
        print( "DHT Checksum error." );
    elseif( status == dht.ERROR_TIMEOUT ) then
        node.restart()
        --print( "DHT Time out." );
    end
end    

ReadDHT()
u8g_test()
tmr.alarm(1,1000*60*1,1,function()ReadDHT()u8g_test()end)

--u8g_test()
