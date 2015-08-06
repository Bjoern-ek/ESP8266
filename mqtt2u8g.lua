function init_OLED(sda, scl)
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
     disp:setFont(u8g.font_6x10)
     disp:setFontRefHeightExtendedText()
     disp:setDefaultForegroundColor()
     disp:setFontPosTop()
end

init_OLED(3,4) --ESP8266-1

function u8g_test()

    disp:firstPage()
    repeat
        disp:drawRFrame(0, 0, 128, 16, 3)   -- ein Rahmen mit runden ecken
        disp:drawStr(2, 3, Text1)           -- text aus einer variablen
        disp:drawStr(2, 16, werte)
        --disp:drawStr(2, 28, "Luftfeuchte: "..humi.." %")
        --disp:drawBox(40,40, math.floor(temp), 8)        -- die Temperatur als Balken
        --disp:drawStr(40,48, "0")                        -- eine 0 als anfang
        --disp:drawStr(math.floor(temp)+42, 40, temp.."C")
    until disp:nextPage() == false
    
end

Text1 = "Ditmar ist nett!"
werte = "XX YY"         -- vorbelegen

-- initiate the mqtt client and set keepalive timer to 60sec
m = mqtt.Client(ESP82661, 60)

-- nur fuer debug
--m:on("connect", function(con) print ("connect") end)
--m:on("offline", function(con) print ("offline") end)

m:connect(mqtt_host, 1883, 0, function(conn)
  print("connected")        -- stehenlassen, wichtig
  -- subscribe topic with qos = 0
  m:subscribe(mqtt_topic,0, function(conn)
  end)
end)

-- on receive message
m:on("message", function(conn, topic, data)
  --print(topic .. ":" )
  if data ~= nil then
    --print(data)
    werte = (data)      -- in eine neue variable
    --print(werte)
    u8g_test()
  end
    
end)


u8g_test()