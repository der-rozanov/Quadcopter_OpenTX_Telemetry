--===============================================================================--
pitch = 0 --pitch
roll = 0 --roll
yaw = 0 --yaw
rss1 = 0 --Connection quality
rss2 = 0 --Connection quality
flight_mode = 0 --Flightmode
tx_voltage = 0 --Your transmitter voltage
fuel = 0 --Remaining charge as a percentage
capa = 0 --Used battery capacity
bat_voltage = 0 --Battery voltage 
current = 0 --Current in the power supply circuit
tpw = 0 --signal power
t_qly = 0 --transmission quality 

bat_min = 3.5
max_cap = 1350
--===============================================================================--

local function drawFrame()
  --Draw main frame on screen. LCD width 127, height 63
  --[[
        __________________________8          ____x pos  y pos
		0     40   		87     127                        |
		|     |    		 |      |                         |
		|     |-43    84-|23    |
		|     |__________|      |
		|     |    		 |45    |
		|     |    		 |      |
  ]]
  lcd.drawLine(40,8,40,63,SOLID,FORCE)
  lcd.drawLine(87,8,87,63,SOLID,FORCE)
  lcd.drawLine(40,27,43,27,SOLID,FORCE)
  lcd.drawLine(84,27,87,27,SOLID,FORCE)
  lcd.drawLine(40,45,87,45,SOLID,FORCE)
  
end

local function drawBatteryData(xz, yz)
  
  lcd.drawGauge(xz+1,yz+9,xz+37,yz+8,fuel,100)
  lcd.drawLine(xz+38,yz+12,xz+38,yz+13,SOLID,FORCE)
  
  lcd.drawText(xz+1,yz+19,"Bt",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos(),yz+19,10*bat_voltage,PREC1+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),yz+19,"V",SMLSIZE)
  
  lcd.drawText(xz+1,yz+27,"Cp",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos(),yz+27,capa,SMLSIZE)
  
  lcd.drawText(xz+1,yz+35,"Cur",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos(),yz+35,current*10,PREC1+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),yz+35,"A",SMLSIZE)
  
  lcd.drawText(xz+1,yz+43,"Tx",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2,yz+43,100*getValue("tx-voltage"),SMLSIZE+PREC2)
  lcd.drawText(lcd.getLastPos(),yz+43,"V",SMLSIZE)
  
end  

local function drawOtherData(zx,zy)
  
  lcd.drawText(zx+2,zy+9,"RS1",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2,zy+9,rss1,SMLSIZE)
  lcd.drawText(lcd.getLastPos(),zy+9,"dB",SMLSIZE)
  
  lcd.drawText(zx+2, zy+16,"RS2",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2, zy+16, rss2, SMLSIZE)
  lcd.drawText(lcd.getLastPos(), zy+16,"dB",SMLSIZE)
  
  lcd.drawText(zx+2, zy+32,"TQ",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2, zy+32,t_qly, SMLSIZE)
  lcd.drawText(lcd.getLastPos(), zy+32,"%",SMLSIZE)
  
  lcd.drawText(zx+2, zy+40,"SP",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2, zy+40,tpw, SMLSIZE)
  lcd.drawText(lcd.getLastPos(), zy+40,"mW",SMLSIZE)
end

local function drawBird(zx,zy,roll,pitch)

	local y0 = zy+27 - 17*math.sin(pitch)
	local x0 = zx+24 
	local leng = 17

	lcd.drawLine(x0,y0,x0+leng*math.cos(roll),y0+leng*math.sin(roll),SOLID,FORCE)
	lcd.drawLine(x0,y0,x0-leng*math.cos(roll),y0-leng*math.sin(roll),SOLID,FORCE)
	
	if (math.abs(roll) > math.pi/2) then 
		lcd.drawText(zx+10, zy+35, "invert", BLINK, SMLSIZE)
	end
end

local function drawFM(xz, yz)

	lcd.drawText(xz+14,yz+5,flight_mode,SMLSIZE)
	
end

local function drawMasterWarning()

	

end

--======================================================================
--Edit this "parameters" like its write in you transmitter 
local function getTelemeryValue()
  pitch = getValue("Ptch")
  roll = getValue("Roll") 
  yaw = getValue("Yaw")
  rss1 = getValue("1RSS")
  rss2 = getValue("2RSS")
  flight_mode = getValue("FM")
  tx_voltage = getValue("tx-voltage")
  fuel = getValue("Bat_")
  capa = getValue("Capa")
  bat_voltage = getValue("RxBt")
  current =getValue("Curr")
  tpw = getValue("TPW2")
  t_qly = getValue("TQly")
end
--======================================================================


local function run_func(event)

  lcd.clear() --clear lcd display
  
  lcd.drawScreenTitle("Quattro Telemetry",1,1) --put there current version
  
  getTelemeryValue()
  
  drawFrame()
  
  drawBatteryData(0, 0)
  
  drawOtherData(87,0)
  
  drawBird(40,0,roll,pitch)
  
  drawFM(40,35) --45
  
  if event == EVT_EXIT_BREAK then   --if "Exit" button pressed, stop program
    return 1 
  else
    return 0
  end
  
end


return { run=run_func } --looping the program