
----------------------------------- LOCATE DATAREFS -----------------------------------

-- ASSOCIATING VARIABLES TO ANNUNCIATORS OR CONDITIONS OF THE SYSTEMS WE WANT TO DISPLAY AN ALERT

fuelpressL = find_dataref("sim/cockpit2/annunciators/fuel_pressure_low[0]")
fuelpressR = find_dataref("sim/cockpit2/annunciators/fuel_pressure_low[1]")
fuelpumpC = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
fuelpumpL = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
fuelpumpR = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")
hydpress = find_dataref("sim/cockpit2/annunciators/hydraulic_pressure")
oilpressL = find_dataref("sim/cockpit2/annunciators/oil_pressure_low[0]")
oilpressR = find_dataref("sim/cockpit2/annunciators/oil_pressure_low[1]")
yawdamp = find_dataref("sim/cockpit2/annunciators/yaw_damper")
parkbrake = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
pitotheat = find_dataref("sim/cockpit2/annunciators/pitot_heat")
generatorL = find_dataref("sim/cockpit2/annunciators/generator_off[0]")
generatorR = find_dataref("sim/cockpit2/annunciators/generator_off[1]")
generatorAPU = find_dataref("sim/cockpit2/electrical/APU_generator_on")
APUN1percent = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
APU_bleedair_switch = find_dataref("laminar/md82/bleedair/APU_on")
bleedair = find_dataref("sim/cockpit2/pressurization/actuators/bleed_air_mode") --> (0=off,1=left,2=both,3=right,4=apu,5=auto)
bleedairL = find_dataref("sim/cockpit2/annunciators/bleed_air_off[0]")
bleedairR = find_dataref("sim/cockpit2/annunciators/bleed_air_off[1]")
low_voltage = find_dataref("sim/cockpit2/annunciators/low_voltage")

autoboard_in_progress = find_dataref("sim/flightmodel2/misc/auto_board_in_progress")
autostart_in_progress = find_dataref("sim/flightmodel2/misc/auto_start_in_progress")




----------------------------------- CREATE DATAREFS -----------------------------------
-- each msgN is a line of the eoap displays: write inside msgN strings mean write on the eoap
-- (max 20 char each line including spaces)
msg0 = create_dataref("laminar/md82/EOAP/msg0","string")
msg1 = create_dataref("laminar/md82/EOAP/msg1","string")
msg2 = create_dataref("laminar/md82/EOAP/msg2","string")
msg3 = create_dataref("laminar/md82/EOAP/msg3","string")
msg4 = create_dataref("laminar/md82/EOAP/msg4","string")
msg5 = create_dataref("laminar/md82/EOAP/msg5","string")
msg6 = create_dataref("laminar/md82/EOAP/msg6","string")
msg7 = create_dataref("laminar/md82/EOAP/msg7","string")
msg8 = create_dataref("laminar/md82/EOAP/msg8","string")
msg9 = create_dataref("laminar/md82/EOAP/msg9","string")
msg10 = create_dataref("laminar/md82/EOAP/msg10","string")
msg11 = create_dataref("laminar/md82/EOAP/msg11","string")




--------------------------------- CREATING FUNCTIONS TO CALL BACK ---------------------------------

-- FUNCTION: RESET THE EOAP
function reset_eoap()
	msg0 = ""
	msg1 = ""
	msg2 = ""
	msg3 = ""
	msg4 = ""
	msg5 = ""
	msg6 = ""
	msg7 = ""
	msg8 = ""
	msg9 = ""
	msg10 = ""
	msg11 = ""
	Nmsg = 0
end









-- FUNCTION: CHECK IF A MESSAGE IS ALREADY ON DISPLAYS
function checkEXSISTmsg()
	isalreadypresent = 0
	yetcheck = 0
	if msg == msg0 then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg1) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg2) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg3) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg4) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg5) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg6) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg7) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg8) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg9) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg10) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	if (msg == msg11) and (yetcheck == 0) then isalreadypresent = 1 yetcheck = 1 end
	return isalreadypresent
end








-- FUNCTION: WRITE THE ALERT MESSAGE ON THE EOAP IN THE FIRST EMPTY LINE
function filldisplays()
	yetwrite = 0
	if msg0 == "" then msg0 = msg yetwrite = 1 end
	if (msg1 == "") and (yetwrite == 0) then msg1 = msg yetwrite = 1 end
	if (msg2 == "") and (yetwrite == 0) then msg2 = msg yetwrite = 1 end
	if (msg3 == "") and (yetwrite == 0) then msg3 = msg yetwrite = 1 end
	if (msg4 == "") and (yetwrite == 0) then msg4 = msg yetwrite = 1 end
	if (msg5 == "") and (yetwrite == 0) then msg5 = msg yetwrite = 1 end
	if (msg6 == "") and (yetwrite == 0) then msg6 = msg yetwrite = 1 end
	if (msg7 == "") and (yetwrite == 0) then msg7 = msg yetwrite = 1 end
	if (msg8 == "") and (yetwrite == 0) then msg8 = msg yetwrite = 1 end
	if (msg9 == "") and (yetwrite == 0) then msg9 = msg yetwrite = 1 end
	if (msg10 == "") and (yetwrite == 0) then msg10 = msg yetwrite = 1 end
	if (msg11 == "") and (yetwrite == 0) then msg11 = msg yetwrite = 1 end
	Nmsg = Nmsg + 1
end









-- FUNCTION: SEARCH AND REMOVE THE ALERT MESSAGE FROM THE EOAP
function removemsg()
	if msg0 == msg then msg0 = "" end
	if msg1 == msg then msg1 = "" end
	if msg2 == msg then msg2 = "" end
	if msg3 == msg then msg3 = "" end
	if msg4 == msg then msg4 = "" end
	if msg5 == msg then msg5 = "" end
	if msg6 == msg then msg6 = "" end
	if msg7 == msg then msg7 = "" end
	if msg8 == msg then msg8 = "" end
	if msg9 == msg then msg9 = "" end
	if msg10 == msg then msg10 = "" end
	if msg11 == msg then msg11 = "" end
	Nmsg = Nmsg - 1
end








-- FUNCTION: RE-ARRANGE ALERT MESSAGES BY REMOVING EMPTY LINES FROM THE EOAP
function rearrange()

	-- test message overlapped:
	-- msg11 = "MD80 BETA-TOT MSG:"..Nmsg

	if msg11 == "" then msg11 = "" end
	if msg10 == "" then msg10 = msg11 msg11 = "" end
	if msg9 == "" then msg9 = msg10 msg10 = "" end
	if msg8 == "" then msg8 = msg9 msg9 = "" end
	if msg7 == "" then msg7 = msg8 msg8 = "" end
	if msg6 == "" then msg6 = msg7 msg7 = "" end
	if msg5 == "" then msg5 = msg6 msg6 = "" end
	if msg4 == "" then msg4 = msg5 msg5 = "" end
	if msg3 == "" then msg3 = msg4 msg4 = "" end
	if msg2 == "" then msg2 = msg3 msg3 = "" end
	if msg1 == "" then msg1 = msg2 msg2 = "" end
	if msg0 == "" then msg0 = msg1 msg1 = "" end
end






-------------------------------------- RUNTIME CODE --------------------------------------


-- RESET THE EOAP TO EMPTY EACH FLIGHT START
function flight_start()
	reset_eoap()
end




-- THE FOLLOWING IS JUST A DRAFT, WE NOT COVER ALL POSSIBLE ALERT MESSAGES
-- THE FUNCTION CALL TO UPDATE THE EOAP WHEN A CONDITION OCCUR (if/else)
-- MAX 20 CHAR FOR EACH MESSAGE (including spaces)
-- RIGHT NOW THE SCRIPT WILL NOT DISPLAY MORE THAN 12 MSG LINES (no scrolling arrows function)

function after_physics()

	-- check for alert conditions and set the relative message
	-- # 01
	if fuelpressL == 1 then
		msg = "L INLET FUEL PRES LO"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L INLET FUEL PRES LO"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 02
	if fuelpressR == 1 then
		msg = "R INLET FUEL PRES LO"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "R INLET FUEL PRES LO"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 03
	if hydpress == 1 then
		msg = "HYDRAULIC PRESS LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "HYDRAULIC PRESS LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 04
	if (oilpressL == 1) or (oilpressR == 1) then
		msg = "L-R OIL PRESS LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L-R OIL PRESS LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 05
	if yawdamp == 0 then
		msg = "YAW DAMP OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "YAW DAMP OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 06
	if APUN1percent > 95 and APU_bleedair_switch == 0 then
		msg = "APU BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "APU BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 07
	if parkbrake >= 0.5 then
		msg = "PARKING BRAKES ON"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "PARKING BRAKES ON"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 08
	if pitotheat == 1 then
		msg = "PITOT/STALL HEAT OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "PITOT/STALL HEAT OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 09 L
	if generatorL == 1 and generatorR == 0 then
		msg = "L GEN OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L GEN OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 09 R
	if generatorL == 0 and generatorR == 1 then
		msg = "R GEN OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "R GEN OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 09 L-R
	if generatorL == 1 and generatorR == 1 then
		msg = "L-R GEN OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L-R GEN OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 10
	if generatorAPU == 0 then
		msg = "APU GEN OFF"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "APU GEN OFF"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 11 L
	if bleedairL == 1 and bleedairR == 0 then
		msg = "L BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 11 R
	if bleedairL == 0 and bleedairR == 1 then
		msg = "R BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "R BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 11 L-R
	if bleedairL == 1 and bleedairR == 1 then
		msg = "L-R BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "L-R BLEED AIR LOW"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 12
	if low_voltage == 1 then
		msg = "AC-DC BUS LOW VOLT"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "AC-DC BUS LOW VOLT"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 13 autoboard info
	if autoboard_in_progress == 1 then
		msg = "*****AUTO-BOARD*****"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
		msg = "*****IS-RUNNING*****"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "*****AUTO-BOARD*****"
		if checkEXSISTmsg() == 1 then removemsg() end
		msg = "*****IS-RUNNING*****"
		if checkEXSISTmsg() == 1 then removemsg() end
	end
	-- # 14 autostart info
	if autostart_in_progress == 1 then
		msg = "*****AUTO START*****"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
		msg = "*****IS RUNNING*****"
		if checkEXSISTmsg() == 1 then msg = "" else filldisplays() end
	else
		msg = "*****AUTO START*****"
		if checkEXSISTmsg() == 1 then removemsg() end
		msg = "*****IS RUNNING*****"
		if checkEXSISTmsg() == 1 then removemsg() end
	end


	rearrange()

end







