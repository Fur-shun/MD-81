
--
-- THIS SCRIPT OVERRIDE THE X-PLANE DEFAULT COMMANDS FOR
-- AUTOBOARD ("Prep electrical system for boarding" menu)
-- AND AUTOSTART ("Start engines to running" menu)
--
-- IT TAKE ALL THE NECESSARY DATAREFS AND COMMANDS TO START THE MD80
-- SETTING/INVOKING THEM IN THE RIGHT SEQUENCE
-- 




----------------------------------- LOCATE DATAREFS AND COMMANDS -----------------------------------

autoboard_in_progress = find_dataref("sim/flightmodel2/misc/auto_board_in_progress")
autostart_in_progress = find_dataref("sim/flightmodel2/misc/auto_start_in_progress")

parking_brake_ratio = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
main_battery = find_dataref("sim/cockpit2/electrical/battery_on[0]")
main_battery_lockCMD = find_command("laminar/md82cmd/safeguard03")
main_battery_lock = find_dataref("laminar/md82/safeguard[3]")
beacon_on = find_dataref("sim/cockpit2/switches/beacon_on")
local_time_hours = find_dataref("sim/cockpit2/clock_timer/local_time_hours")
strobe_lights_on = find_dataref("sim/cockpit2/switches/strobe_lights_on")
navigation_lights_on = find_dataref("sim/cockpit2/switches/navigation_lights_on")
--landing_lights_switch_nose = find_dataref("sim/cockpit2/switches/landing_lights_switch[0]") --> no more: use taxi
landing_lights_switch_nose = find_dataref("sim/cockpit2/switches/taxi_light_on")
landing_lights_switch_L = find_dataref("sim/cockpit2/switches/landing_lights_switch[1]")
landing_lights_switch_R = find_dataref("sim/cockpit2/switches/landing_lights_switch[2]")
logo_lights = find_dataref("sim/cockpit2/switches/generic_lights_switch[0]")
start_pump = find_dataref("sim/cockpit2/engine/actuators/fuel_pump_on[0]")
APU_starter_switch = find_dataref("sim/cockpit2/electrical/APU_starter_switch")
APU_N1_percent = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
cross_tie_APU_L = find_dataref("laminar/md82/electrical/cross_tie_APU_L")
cross_tie_APU_R = find_dataref("laminar/md82/electrical/cross_tie_APU_R")
cross_tie_AC = find_dataref("laminar/md82/electrical/cross_tie_AC")
cross_tie_DC = find_dataref("laminar/md82/electrical/cross_tie_DC")
yaw_damper_on = find_dataref("sim/cockpit2/switches/yaw_damper_on")
selheatknob_upCMD = find_command("laminar/md82cmd/ice/selheatknob_up")
heatknob = find_dataref("laminar/md82/ice/heatknob")
bleedair_APU_switch = find_dataref("laminar/md82/bleedair/APU_on")
bleedair_needle = find_dataref("laminar/md82/bleedair/bleedair_needle")
fuel_tank_pump_C = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
fuel_tank_pump_L = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
fuel_tank_pump_R = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")
electric_hydraulic_pump_on = find_dataref("sim/cockpit2/switches/electric_hydraulic_pump_on")
flight_director_mode = find_dataref("sim/cockpit2/autopilot/flight_director_mode")
clear_master_cautionCMD = find_command("sim/annunciator/clear_master_caution")

R_xfeed_lever = find_dataref("laminar/md82/bleedair/engineR_xfeed_lever")
L_xfeed_lever = find_dataref("laminar/md82/bleedair/engineL_xfeed_lever")
L_xfeed_toggleCMD = find_command("laminar/md82cmd/bleedair/L_xfeed_lever_toggle")
R_xfeed_toggleCMD = find_command("laminar/md82cmd/bleedair/R_xfeed_lever_toggle")
engage_starter_L_CMD = find_command("sim/starters/engage_starter_1")
engage_starter_R_CMD = find_command("sim/starters/engage_starter_2")
mixture_ratio_L = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[0]")
mixture_ratio_R = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[1]")
N2_percent_L = find_dataref("sim/cockpit2/engine/indicators/N2_percent[0]")
N2_percent_R = find_dataref("sim/cockpit2/engine/indicators/N2_percent[1]")
generator_onL = find_dataref("sim/cockpit2/electrical/generator_on[0]")
generator_onR = find_dataref("sim/cockpit2/electrical/generator_on[1]")
throttle_L = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[0]")
throttle_R = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[1]")


------------------------------- FUNCTIONS AND COMMANDS CALLBACK -------------------------------

-- ANIMATION FUNCTION
function update_slowly(position,positionNEW,speed)
	position = position + ((positionNEW - position) * (speed * SIM_PERIOD))
	return position
end



-- COMMANDS CALLBACK:

function sim_autoboard_CMDhandler(phase, duration)
    if phase == 0 then
        --AUTOBOARD COMMAND INVOKED
        if autoboard_in_progress == 0 and autostart_in_progress == 0 then
			autoboard_step = 1
			autoboard_in_progress = 1
		end
    end
end

function sim_autostart_CMDhandler(phase, duration)
    if phase == 0 then
	--AUTOSTART COMMAND INVOKED
        if autoboard_in_progress == 0 and autostart_in_progress == 0 then
			autostart_step = 1
			autostart_in_progress = 1
        end
    end
end


CMD_autoboard = replace_command("sim/operation/auto_board", sim_autoboard_CMDhandler)
CMD_autostart = replace_command("sim/operation/auto_start", sim_autostart_CMDhandler)






----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	autoboard_step = 0
	autostart_step = 0
	autoboard_in_progress = 0
	autostart_in_progress = 0
end




-- REGULAR RUNTIME
function after_physics()

	------------------------
	-- AUTOBOARD SEQUENCE --
	------------------------
	if (autoboard_step == 1) then

		parking_brake_ratio = 1					-- apply full park brake
		main_battery = 1					-- turn on the main battery
		if main_battery_lock == 0 then
			main_battery_lockCMD:once()			-- lock the battery switch by invoking the command once
		end
		beacon_on = 1						-- turn on anti collision beacons
		start_pump = 1						-- turn on aux electric fuel pump
		APU_starter_switch = 2					-- engage APU starter
		autoboard_step = 2					-- go to the next step

	elseif (autoboard_step == 2) and (APU_N1_percent > 95) then	-- wait until the APU N1 reach 95%
		APU_starter_switch = 1					-- APU starter to "run"
		cross_tie_APU_L = 1					-- turn the L bus connection with the APU power to on
		cross_tie_APU_R = 1					-- turn the R bus connection with the APU power to on
		cross_tie_AC = 1					-- cross tie AC to auto
		cross_tie_DC = 1					-- cross tie DC to close
		yaw_damper_on = 1					-- turn on the yaw damper
		if heatknob == 0 then
			selheatknob_upCMD:once()			-- turn the pitot heat knob up a notch
		end
		strobe_lights_on = 1					-- turn on strobe lights
		navigation_lights_on = 1				-- turn on nav lights
		if local_time_hours < 6 or local_time_hours > 18 then
			landing_lights_switch_nose = 2			-- turn on nose taxi lights
			landing_lights_switch_L = 1			-- turn on L landing light
			landing_lights_switch_R = 1			-- turn on R landing light
			logo_lights = 1					-- turn on tail logo lights
		else
			landing_lights_switch_L = -1			-- retract the L landing light
			landing_lights_switch_R = -1			-- retract the R landing light
		end
		start_pump = 0						-- turn off aux electric fuel pump
		bleedair_APU_switch = 1					-- turn on the bleed air from APU
		autoboard_step = 3					-- go to the next step

	elseif (autoboard_step == 3) and (bleedair_needle > 2.0) then	-- wait until bleedair reach 2.0
		fuel_tank_pump_L = 1					-- turn on fuel pump L tank
		fuel_tank_pump_C = 1					-- turn on fuel pump Central tank
		fuel_tank_pump_R = 1					-- turn on fuel pump R tank
		flight_director_mode = 1				-- turn on the autopilot in FD mode (not the servos)
		electric_hydraulic_pump_on = 1				-- auxiliary hydraulic pump on
		autoboard_step = 4					-- go to the next step

	elseif (autoboard_step == 4) then
		-------------------------------------------------
		-- SLOWLY TURN OFF L ENGINE IF ALREADY RUNNING --
		-------------------------------------------------
		if N2_percent_L > 10 or mixture_ratio_L > 0 then
			mixture_ratio_L = update_slowly(mixture_ratio_L,0,2.5)
			if mixture_ratio_L < 0.1 then
				mixture_ratio_L = 0
				--generator_onL = 0			-- turn off the generator for this engine
			end
		else
			autoboard_step = 5				-- go to the next step
		end

	elseif (autoboard_step == 5) then
		-------------------------------------------------
		-- SLOWLY TURN OFF R ENGINE IF ALREADY RUNNING --
		-------------------------------------------------
		if N2_percent_R > 10 or mixture_ratio_R > 0 then
			mixture_ratio_R = update_slowly(mixture_ratio_R,0,2.5)
			if mixture_ratio_R < 0.1 then
				mixture_ratio_R = 0
				--generator_onR = 0			-- turn off the generator for this engine
			end
		else
			autoboard_step = 6				-- go to the next step
		end

	elseif (autoboard_step == 6) then
		clear_master_cautionCMD:once()				-- turn off the master caution
		autoboard_in_progress = 0				-- autoboard sequence done
		autoboard_step = 999

	else
		--nothing
	end



	------------------------
	-- AUTOSTART SEQUENCE --
	------------------------
	if (autostart_step == 1) and (autoboard_step == 0) then		-- run autoboard if it is not already done
		autoboard_step = 1
	end

	if (autostart_step == 1) and (autoboard_step == 999) then	-- only go ahead if autoboard is done
		------------------------
		-- RIGHT ENGINE START --
		------------------------
		generator_onR = 1					-- turn on the generator for this engine
		throttle_R = 0
		if L_xfeed_lever == 1 then L_xfeed_toggleCMD:once() end	-- set the left bleedair/crossfeed lever to close
		if R_xfeed_lever == 0 then R_xfeed_toggleCMD:once() end	-- set the right bleedair/crossfeed lever to open
		engage_starter_R_CMD:start()				-- right starter on, keeping it engaged
		autostart_step = 2					-- go to the next step

	elseif (autostart_step == 2) and (N2_percent_R > 20) then	-- wait until the N2 raise the 20%
		engage_starter_R_CMD:stop()				-- right starter released
		autostart_step = 3					-- go to the next step

	elseif (autostart_step == 3) then
		mixture_ratio_R = update_slowly(mixture_ratio_R,1,2.5)	-- slowly open the fuel for the right engine
		if mixture_ratio_R > 0.9 then
			mixture_ratio_R = 1				-- mixture fully rich
			autostart_step = 4				-- go to the next step
		end

	elseif (autostart_step == 4) then
		if N2_percent_R > 52 then				-- wait until N2 reach 52%
			autostart_step = 5				-- go to the next step
		else
			autostart_step = 3				-- keep mixture rich if not
		end

	elseif (autostart_step == 5) then
		------------------------
		-- LEFT ENGINE START --
		------------------------
		generator_onL = 1					-- turn on the generator for this engine
		throttle_L = 0
		if L_xfeed_lever == 0 then L_xfeed_toggleCMD:once() end	-- set the left bleedair/crossfeed lever to open
		if R_xfeed_lever == 1 then R_xfeed_toggleCMD:once() end	-- set the right bleedair/crossfeed lever to close
		engage_starter_L_CMD:start()				-- left starter on, keeping it engaged
		autostart_step = 6					-- go to the next step

	elseif (autostart_step == 6) and (N2_percent_L > 20) then	-- wait until the N2 raise the 20%
		engage_starter_L_CMD:stop()				-- left starter released
		autostart_step = 7					-- go to the next step

	elseif (autostart_step == 7) then
		mixture_ratio_L = update_slowly(mixture_ratio_L,1,2.5)	-- slowly open the fuel for the left engine
		if mixture_ratio_L > 0.9 then
			mixture_ratio_L = 1				-- mixture fully rich
			autostart_step = 8				-- go to the next step
		end

	elseif (autostart_step == 8) then
		if N2_percent_L > 52 then				-- wait until N2 reach 52%
			autostart_step = 9				-- go to the next step
		else
			autostart_step = 7				-- keep mixture rich if not
		end

	elseif (autostart_step == 9) then
		if L_xfeed_lever == 0 then L_xfeed_toggleCMD:once() end	-- set the left bleedair/crossfeed lever to open
		if R_xfeed_lever == 0 then R_xfeed_toggleCMD:once() end	-- set the right bleedair/crossfeed lever to open
		autostart_step = 10					-- go to the next step

	elseif (autostart_step == 10) then
		------------------------
		--- TURN OFF THE APU ---
		------------------------
		bleedair_APU_switch = 0					-- turn the bleed air from APU to off
		cross_tie_APU_L = 0					-- turn the L bus connection with the APU power to off
		cross_tie_APU_R = 0					-- turn the R bus connection with the APU power to off
		APU_starter_switch = 0					-- APU starter to "off"
		autostart_step = 11					-- go to the next step

	elseif (autostart_step == 11) then
		autostart_in_progress = 0				-- autostart sequence done
		autostart_step = 999

	else
		--nothing
	end



	------------------------
	---- RESETTING STEPS ---
	------------------------
	if (autoboard_step == 999) and (autostart_step == 999) then	-- reset both to 0 if both are accomplished
		autoboard_step = 0
		autostart_step = 0
	end


end


