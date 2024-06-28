
-- XPLANE CAN JUST HAVE ONE BLEED AIR INPUT MODE AT A TIME: 0=OFF, 1=LEFT ENGINE, 2=BOTH ENGINES, 3=RIGHT ENGINE, 4=APU, 5=AUTO
-- SO WE WILL HANDLE THE VARIOUS MD80's LEVERS AND SWITCHES WHO DEAL WITH BLEED AIR TO SET THAT MODE ACCORDINGLY.
-- ALSO THERE IS A SIMPLE HVAC (air conditioning) SIMULATED SYSTEM DRIVING RELATIVE NEEDLES AND SWITCHES.



----------------------------------- LOCATE AND CREATE DATAREFS -----------------------------------
startuprunning = find_dataref("sim/operation/prefs/startup_running")
bleedair_mode = find_dataref("sim/cockpit2/pressurization/actuators/bleed_air_mode") --> (0=off,1=left,2=both,3=right,4=apu,5=auto)
APU_N1 = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
GPU_on = find_dataref("sim/cockpit/electrical/gpu_on")
engineL_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
engineR_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")
starterL_on = find_dataref("sim/flightmodel2/engines/starter_is_running[0]")
starterR_on = find_dataref("sim/flightmodel2/engines/starter_is_running[1]")
outside_air_temp_C = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")


-- FUNCTIONS FOR WRITABLE DATAREFS

function xfeed_L_func()
	if engineL_xfeed_lever > 0.5 then xfeedNEWL = 1 else xfeedNEWL = 0 end
end
function xfeed_R_func()
	if engineR_xfeed_lever > 0.5 then xfeedNEWR = 1 else xfeedNEWR = 0 end
end

function HVAC_L_knob_func()
end
function HVAC_R_knob_func()
end
function temp_source_knob_func()
end


bleedair_APU_switch = create_dataref("laminar/md82/bleedair/APU_on","number") --> the switch in the apu plate (0=off, 1=on, 2=air cond cooler)
bleedair_needle = create_dataref("laminar/md82/bleedair/bleedair_needle","number") --> the needle in the engine plate
engineL_xfeed_lever = create_dataref("laminar/md82/bleedair/engineL_xfeed_lever","number",xfeed_L_func) --> the lever of the L engine on the pedestal
engineR_xfeed_lever = create_dataref("laminar/md82/bleedair/engineR_xfeed_lever","number",xfeed_R_func) --> the lever of the R engine on the pedestal
bleedair_HVAC_L = create_dataref("laminar/md82/bleedair/bleedair_HVAC_L","number") --> air conditioning L 0=off, 1=on, 2=auto
bleedair_HVAC_R = create_dataref("laminar/md82/bleedair/bleedair_HVAC_R","number") --> air conditioning R 0=off, 1=on, 2=auto
bleedair_HVAC_L_pressure = create_dataref("laminar/md82/bleedair/HVAC_L_press","number") --> air condit L press needle
bleedair_HVAC_R_pressure = create_dataref("laminar/md82/bleedair/HVAC_R_press","number") --> air condit R press needle
bleedair_HVAC_L_temp = create_dataref("laminar/md82/bleedair/HVAC_L_temp","number") --> air condit L temp needle (-1=cold, 1=hot)
bleedair_HVAC_R_temp = create_dataref("laminar/md82/bleedair/HVAC_R_temp","number") --> air condit R temp needle (-1=cold, 1=hot)
bleedair_HVAC_L_knob = create_dataref("laminar/md82/bleedair/HVAC_L_knob","number",HVAC_L_knob_func) --> air condit CKPT knob (-1=cold, 1=hot)
bleedair_HVAC_R_knob = create_dataref("laminar/md82/bleedair/HVAC_R_knob","number",HVAC_R_knob_func) --> air condit CABIN knob (-1=cold, 1=hot)
bleedair_temp_source_knob = create_dataref("laminar/md82/bleedair/temp_source","number",temp_source_knob_func) --> (0=cabin sply, 1=cabin)
bleedair_temp_cabin_C = create_dataref("laminar/md82/bleedair/temp_cabin","number") --> the cabin C° needle

bleedair_temp_cabin_C = outside_air_temp_C




------------------------------- FUNCTIONS -------------------------------

-- ANIMATION FUNCTION
function update_slowly(position, positionNEW, speed)
	SPD_PERIOD = speed * SIM_PERIOD
	if SPD_PERIOD > 1 then SPD_PERIOD = 1 end
	position = position + ((positionNEW - position) * SPD_PERIOD)
	delta = math.abs(position - positionNEW)
	if delta < 0.05 then position = positionNEW end
	return position
end






------------------------------- FUNCTIONS: COMMANDS CALLBACK AND CREATION -------------------------------

-- APU SWITCH UP/DWN FUNCTIONS
function APU_switch_up(phase, duration)
	if phase == 0 then
		if (bleedair_APU_switch > 0) then
			bleedair_APU_switch = bleedair_APU_switch - 1
		else
			bleedair_APU_switch = 0
		end
	end
end

function APU_switch_dwn(phase, duration)
	if phase == 0 then
		if (bleedair_APU_switch < 2) then
			bleedair_APU_switch = bleedair_APU_switch + 1
		else
			bleedair_APU_switch = 2
		end
	end
end

-- ENGINES X FEED LEVERS TOGGLE FUNCTIONS
function L_xfeed_lever_toggle(phase, duration)
	if phase == 0 then
		 -- toggle from 0 to 1 and viceversa
		if xfeedNEWL == 0 then xfeedNEWL = 1 elseif xfeedNEWL == 1 then xfeedNEWL = 0 end
	end
end

function R_xfeed_lever_toggle(phase, duration)
	if phase == 0 then
		 -- toggle from 0 to 1 and viceversa
		if xfeedNEWR == 0 then xfeedNEWR = 1 elseif xfeedNEWR == 1 then xfeedNEWR = 0 end
	end
end

-- HVAC SWITCHES UP/DWN FUNCTIONS
function bleedair_HVAC_L_up(phase, duration)
	if phase == 0 then
		if bleedair_HVAC_L > 0 then bleedair_HVAC_L = bleedair_HVAC_L - 1 end
	end
end

function bleedair_HVAC_L_dwn(phase, duration)
	if phase == 0 then
		if bleedair_HVAC_L < 2 then bleedair_HVAC_L = bleedair_HVAC_L + 1 end
	end
end

function bleedair_HVAC_R_up(phase, duration)
	if phase == 0 then
		if bleedair_HVAC_R > 0 then bleedair_HVAC_R = bleedair_HVAC_R - 1 end
	end
end

function bleedair_HVAC_R_dwn(phase, duration)
	if phase == 0 then
		if bleedair_HVAC_R < 2 then bleedair_HVAC_R = bleedair_HVAC_R + 1 end
	end
end


cmdAPUup = create_command("laminar/md82cmd/bleedair/APU_up","APU bleed air switch up one",APU_switch_up)
cmdAPUdwn = create_command("laminar/md82cmd/bleedair/APU_dwn","APU bleed air switch down one",APU_switch_dwn)
cmdLxfeedlevertog = create_command("laminar/md82cmd/bleedair/L_xfeed_lever_toggle","toggle xfeed lever L",L_xfeed_lever_toggle)
cmdRxfeedlevertog = create_command("laminar/md82cmd/bleedair/R_xfeed_lever_toggle","toggle xfeed lever R",R_xfeed_lever_toggle)
cmdbleedairHVACLup = create_command("laminar/md82cmd/bleedair/bleedair_HVAC_L_up","HVAC_L_up",bleedair_HVAC_L_up)
cmdbleedairHVACLdwn = create_command("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn","HVAC_L_dwn",bleedair_HVAC_L_dwn)
cmdbleedairHVACRup = create_command("laminar/md82cmd/bleedair/bleedair_HVAC_R_up","HVAC_R_up",bleedair_HVAC_R_up)
cmdbleedairHVACRdwn = create_command("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn","HVAC_R_dwn",bleedair_HVAC_R_dwn)









----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	if startuprunning == 1 then
		bleedair_HVAC_L,bleedair_HVAC_R = 2,2
		xfeedNEWL,xfeedNEWR = 1,1
	else
		bleedair_APU_switch = 0
		bleedair_HVAC_L,bleedair_HVAC_R = 0,0
		xfeedNEWL,xfeedNEWR = 0,0
	end
end




-- REGULAR RUNTIME
function after_physics()


	-- SET THE BLEED AIR MODE
	if (bleedair_APU_switch > 0) and (xfeedNEWL == 0) and (xfeedNEWR == 0) then
		bleedair_mode = 4
	elseif (bleedair_APU_switch > 0) and (xfeedNEWL == 1) and (xfeedNEWR == 0) then
		bleedair_mode = 5
	elseif (bleedair_APU_switch > 0) and (xfeedNEWL == 0) and (xfeedNEWR == 1) then
		bleedair_mode = 5
	elseif (bleedair_APU_switch > 0) and (xfeedNEWL == 1) and (xfeedNEWR == 1) then
		bleedair_mode = 5
	elseif (bleedair_APU_switch == 0) and (xfeedNEWL == 1) and (xfeedNEWR == 1) then
		bleedair_mode = 2
	elseif (bleedair_APU_switch == 0) and (xfeedNEWL == 1) and (xfeedNEWR == 0) then
		bleedair_mode = 1
	elseif (bleedair_APU_switch == 0) and (xfeedNEWL == 0) and (xfeedNEWR == 1) then
		bleedair_mode = 3
	else
		bleedair_mode = 0
	end


	-- EVALUATE IF BLEED AIR IS AVAILABLE:
	-- EVALUATE APU BLEED AIR
	if (APU_N1 > 95) and (bleedair_APU_switch > 0) then
		bleedair_available = 1
	-- EVALUATE GPU BLEED AIR
	-- elseif (GPU_on == 1) then
	--	bleedair_available = 1 --> DISABLED: actually the external gpu give electrical power only
	-- EVALUATE ENGINES BLEED AIR
	elseif (engineL_on == 1) and (engineL_xfeed_lever == 1 ) then
		bleedair_available = 1
	elseif (engineR_on == 1) and (engineR_xfeed_lever == 1 ) then
		bleedair_available = 1
	else
		bleedair_available = 0
	end


	-- BLEED AIR CONSUMPTION
	if (bleedair_HVAC_L > 0) or (bleedair_HVAC_R > 0) then
		bleedair_consumption = 1.5
	elseif (starterL_on > 0) or (starterR_on > 0) then
		bleedair_consumption = 2.2
	else
		bleedair_consumption = 0
	end


	-- MOVE THE MAIN BLEED AIR NEEDLE
	if (bleedair_available == 1) then
		bleedair_pressure = (4.0 - bleedair_consumption)
	else
		bleedair_pressure = 0
	end
	if (bleedair_needle ~= bleedair_pressure) then
		bleedair_needle = update_slowly(bleedair_needle,bleedair_pressure,0.50)
	end


	-- MOVE THE HVAC PRESS NEEDLES
	if (bleedair_available == 1) and (bleedair_HVAC_L > 0) then
		HVAC_L_pressNEW = 1
	else
		HVAC_L_pressNEW = 0
	end
	if (bleedair_available == 1) and (bleedair_HVAC_R > 0) then
		HVAC_R_pressNEW = 1
	else
		HVAC_R_pressNEW = 0
	end
	if (bleedair_HVAC_L_pressure ~= HVAC_L_pressNEW) then
		bleedair_HVAC_L_pressure = update_slowly(bleedair_HVAC_L_pressure,HVAC_L_pressNEW,0.50)
	end
	if (bleedair_HVAC_R_pressure ~= HVAC_R_pressNEW) then
		bleedair_HVAC_R_pressure = update_slowly(bleedair_HVAC_R_pressure,HVAC_R_pressNEW,0.50)
	end


	-- MOVE THE HVAC TEMP NEEDLES
	if (bleedair_available == 1) and (bleedair_HVAC_L > 0) then
		bleedair_HVAC_L_temp = update_slowly(bleedair_HVAC_L_temp,bleedair_HVAC_L_knob,0.20)
		else
		bleedair_HVAC_L_temp = update_slowly(bleedair_HVAC_L_temp,0,0.20)
	end
	if (bleedair_available == 1) and (bleedair_HVAC_R > 0) then
		bleedair_HVAC_R_temp = update_slowly(bleedair_HVAC_R_temp,bleedair_HVAC_R_knob,0.20)
		else
		bleedair_HVAC_R_temp = update_slowly(bleedair_HVAC_R_temp,0,0.20)
	end


	-- MOVE THE ENGINES BLEED AIR XFEED LEVERS
	if (engineL_xfeed_lever ~= xfeedNEWL) then
		-- ANIMATION DISABLED DUE TO UNRESOLVED CONFLICT TO THE AUTOSTART SCRIPT
		------engineL_xfeed_lever = xfeedNEWL
		engineL_xfeed_lever = update_slowly(engineL_xfeed_lever,xfeedNEWL,10)
	end
	if (engineR_xfeed_lever ~= xfeedNEWR) then
		-- ANIMATION DISABLED DUE TO UNRESOLVED CONFLICT TO THE AUTOSTART SCRIPT
		------engineR_xfeed_lever = xfeedNEWR
		engineR_xfeed_lever = update_slowly(engineR_xfeed_lever,xfeedNEWR,10)
	end


	-- EVALUATE CABIN AND CABIN SUPPLY DUCT TEMPERATURE (NOT THE COCKPIT)
	average_temp = 22 + outside_air_temp_C/10
	if bleedair_HVAC_R_pressure < 0.2 then average_temp = outside_air_temp_C end
	temp_cabin_C_NEW = average_temp + ((bleedair_HVAC_R_knob * 10) * bleedair_HVAC_R_pressure)
	temp_cabin_C_NEW = temp_cabin_C_NEW - (bleedair_temp_source_knob * 2) --> +2° IF SOURCE IS DUCT
	if temp_cabin_C_NEW < 0 then temp_cabin_C_NEW = 0 end
	if (bleedair_temp_cabin_C ~= temp_cabin_C_NEW) then
		bleedair_temp_cabin_C = update_slowly(bleedair_temp_cabin_C,temp_cabin_C_NEW,0.10)
	end


end











