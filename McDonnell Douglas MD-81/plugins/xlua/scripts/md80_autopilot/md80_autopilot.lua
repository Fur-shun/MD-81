
------------------------------------------------------------------------
-- WELCOME TO THAT AUTOPILOT AND THRUST RATING (EPR) COMPUTER MADNESS --
------------------------------------------------------------------------
--
-- THIS SCRIPT DRIVE THE CUSTOM AUTOTHROTTLE SWITCH,
-- ALL CUSTOM AP BUTTONS,
-- EPR LIMITS(*),
-- SPEED/PITCH MODE/STATUS AND LEVEL CHANGE,
-- TURB (PITCH AND SOFT-RIDE) MODE,
-- THE FMA ANNUNCIATORS TEXT (SAME FOR BOTH PILOT/COPILOT),
-- THE SPEED BUG ON THE ELECTRONIC PFD (BOTH PILOT/COPILOT),
-- THE MACH vs KNOTS BUTTONS,
-- THE BANK ANGLE MODE LIMITS FROM 2 (10°) TO 6 (30°),
-- THE TOGA TAKEOFF OR GO AROUND MODE,
-- AND THE NAV1/NAV2/FMS HSI AUTOPILOT SOURCES.
--
-- (*) MD80 JTD engines measure only the core EPR (EPR of the fan is not measured),
-- X-Plane measures like a Rolls-Royce or an IAE engine (core + fan),
-- so the value X-Plane calculates is lower because the JTDs inidcator doesn’t see half the engine,
-- and that's why all the indicators on instruments in Planemaker are keyframed (1.0 means 1.0 but 1.72 means 2.2).
--




----------------------------------- DATAREFS: LOCATE -----------------------------------

startuprunning = find_dataref("sim/operation/prefs/startup_running")
test_button = find_dataref("sim/cockpit/warnings/annunciator_test_pressed")
bus_volts_1 = find_dataref("sim/cockpit2/electrical/bus_volts[1]")
bus_volts_2 = find_dataref("sim/cockpit2/electrical/bus_volts[2]")
flight_director1_mode = find_dataref("sim/cockpit2/autopilot/flight_director_mode") --> 0 is off, 1 is on, 2 is on with servos
flight_director2_mode = find_dataref("sim/cockpit2/autopilot/flight_director2_mode") --> 0 is off, 1 is on, 2 is on with servos

autothrottle_enabled = find_dataref("sim/cockpit2/autopilot/autothrottle_enabled") --> 0=servos off-declutched (arm/hold), 1=airspeed hold, 2=EPR/N1 target hold, 3=retard, 4=future use

throttle_ratio_all = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
EPR_target_bug_L = find_dataref("sim/cockpit2/engine/actuators/EPR_target_bug[0]")
EPR_target_bug_R = find_dataref("sim/cockpit2/engine/actuators/EPR_target_bug[1]")
red_hi_EPR = find_dataref("sim/aircraft/limits/red_hi_EPR") --> should be 1.73 or so from planemaker

roll_status = find_dataref("sim/cockpit2/autopilot/roll_status") --> status: 0=off, 1=armed, 2=captured
heading_status = find_dataref("sim/cockpit2/autopilot/heading_status")
gpss_status = find_dataref("sim/cockpit2/autopilot/gpss_status")
nav_status = find_dataref("sim/cockpit2/autopilot/nav_status")
--backcourse_status = find_dataref("sim/cockpit2/autopilot/backcourse_status")
TOGA_lateral_status = find_dataref("sim/cockpit2/autopilot/TOGA_lateral_status")
TOGA_pitch_deg = find_dataref("sim/cockpit2/autopilot/TOGA_pitch_deg")
TOGA_status = find_dataref("sim/cockpit2/autopilot/TOGA_status")
pitch_status = find_dataref("sim/cockpit2/autopilot/pitch_status")
sync_hold_pitch_deg = find_dataref("sim/cockpit2/autopilot/sync_hold_pitch_deg")
sync_hold_roll_deg = find_dataref("sim/cockpit2/autopilot/sync_hold_roll_deg")
vvi_status = find_dataref("sim/cockpit2/autopilot/vvi_status")
vvi_dial_fpm = find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")
speed_status = find_dataref("sim/cockpit2/autopilot/speed_status")
altitude_hold_status = find_dataref("sim/cockpit2/autopilot/altitude_hold_status")
altitude_hold_armed = find_dataref("sim/cockpit2/autopilot/altitude_hold_armed")
altitude_dial_ft = find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
altitude_hold_ft = find_dataref("sim/cockpit2/autopilot/altitude_hold_ft")
altitude_ft_pilot = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
glideslope_status = find_dataref("sim/cockpit2/autopilot/glideslope_status")
--vnav_status = find_dataref("sim/cockpit2/autopilot/vnav_status") --> PHYSICAL G1000 ONLY?
fms_vnav = find_dataref("sim/cockpit2/autopilot/fms_vnav") --> just 0=off, 1=on
approach_status = find_dataref("sim/cockpit2/autopilot/approach_status")
--autopilot2_avail = find_dataref("sim/cockpit2/autopilot/autopilot2_avail") --> 0/1
master_flight_director = find_dataref("sim/cockpit2/autopilot/master_flight_director") --> 0=pilot,1=copilot,2=both
flare_status = find_dataref("sim/cockpit2/autopilot/flare_status") --> 0=off,1=arm,2=captured
rollout_status = find_dataref("sim/cockpit2/autopilot/rollout_status") --> 0=off,1=arm,2=captured
--on_ground = find_dataref("sim/flightmodel2/gear/on_ground[0]") --> nose gear
--autopilot_source = find_dataref("sim/cockpit2/autopilot/autopilot_source") --> 0=pilot, 1=copilot
HSI_source_select_pilot = find_dataref("sim/cockpit2/radios/actuators/HSI_source_select_pilot") --> 0=Nav1, 1=Nav2, 2=GPS/FMS
HSI_source_select_copilot = find_dataref("sim/cockpit2/radios/actuators/HSI_source_select_copilot") --> 0=Nav1, 1=Nav2, 2=GPS/FMS
nav2_obs_pilot = find_dataref("sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot")
nav2_obs_copilot = find_dataref("sim/cockpit2/radios/actuators/nav2_obs_deg_mag_copilot")
airspeed_is_mach = find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
pilot_heading_select = find_dataref("sim/cockpit2/autopilot/heading_dial_deg_mag_pilot")
copilot_heading_select = find_dataref("sim/cockpit2/autopilot/heading_dial_deg_mag_copilot")
airspeed_dial_kts_mach = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
airspeed_dial_kts = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")
airspeed_kts_pilot = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
oat_degc = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
--tas_kts_pilot = find_dataref("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
--airspeed_machno = find_dataref("sim/flightmodel/misc/machno")
airspeed_machno = find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
altitude_mode = find_dataref("sim/cockpit2/autopilot/altitude_mode") --> 3=P(pitch/turb), 4=V(vvi), 5=S(speed), 6=(alt), 10=(tkoff-grnd)
radio_alt_ft_pilot = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
flap1_deploy_ratio = find_dataref("sim/flightmodel2/controls/flap1_deploy_ratio")
bank_angle_mode = find_dataref("sim/cockpit2/autopilot/bank_angle_mode") --> 0=auto, 1=5°, 2=10°, 6=30°


----------------------------------- DATAREFS: FUNCTIONS -----------------------------------

-- FUNCTION: MANIPULATOR-WRITABLE ASSUMED-TEMP DATAREF
function EPR_assumed_temp_func()
	if ats_epr_mode == 2 then
		EPR_toflex_CMD:once() --> update values using thrust rating panel computer
	else
		autothrottle_EPR_assumed_temp = (red_hi_EPR*100)-(autothrottle_EPR_limit*100) --> stay the same
	end
end


----------------------------------- DATAREFS: CREATE -----------------------------------

autothrottle_switch = create_dataref("laminar/md82/autopilot/autothrottle_switch","number") --> custom autothrottle switch 0=off, 1=on
autopilot_switch = create_dataref("laminar/md82/autopilot/autopilot_switch","number") --> custom autothrottle switch 0=off, 1=on

autothrottle_EPR_assumed_temp = create_dataref("laminar/md82/autopilot/EPR_assumed_temp","number",EPR_assumed_temp_func) --> ASSUMED TEMP KNOB on the thrust rating panel computer (0->59)
autothrottle_EPR_limit = create_dataref("laminar/md82/autopilot/EPR_limit","number") --> EPR calculated by the thrust rating panel computer (1.0->2.2)

autopilot_source_nav = create_dataref("laminar/md82/autopilot/source_nav","number") --> nav computer source switch: 0=Nav1, 1=Nav2
display_pitch_mode = create_dataref("laminar/md82/autopilot/pitch_mode","number") --> 0=V(vvi) 1=S(ias) 2=M(mach) 3=P(pitch/turbulence)
heading_dial = create_dataref("laminar/md82/autopilot/heading_dial", "number")
alt_dial = create_dataref("laminar/md82/autopilot/alt_dial", "number")

thr0 = create_dataref("laminar/md82/FMA/thr0","string") --> entries of the TARP FMA: Throttle mode first line
thr1 = create_dataref("laminar/md82/FMA/thr1","string") --> entries of the TARP FMA: Throttle mode second line
arm0 = create_dataref("laminar/md82/FMA/arm0","string") --> entries of the TARP FMA: Armed mode first line
arm1 = create_dataref("laminar/md82/FMA/arm1","string") --> entries of the TARP FMA: Armed mode second line
rol0 = create_dataref("laminar/md82/FMA/rol0","string") --> entries of the TARP FMA: Roll mode first line
rol1 = create_dataref("laminar/md82/FMA/rol1","string") --> entries of the TARP FMA: Roll mode second line
pit0 = create_dataref("laminar/md82/FMA/pit0","string") --> entries of the TARP FMA: Pitch mode first line
pit1 = create_dataref("laminar/md82/FMA/pit1","string") --> entries of the TARP FMA: Pitch mode second line












------------------------------- COMMANDS: LOCATE -------------------------------

servos1_toggle_CMD = find_command("sim/autopilot/servos_toggle")
servos2_toggle_CMD = find_command("sim/autopilot/servos2_toggle")
autopilot_ALT_ARM_CMD = find_command("sim/autopilot/altitude_arm")
autopilot_HDG_CMD = find_command("sim/autopilot/heading")
autopilot_NAV_CMD = find_command("sim/autopilot/NAV") --> Autopilot VOR/LOC arm
autopilot_LNAV_CMD = find_command("sim/autopilot/gpss") --> Autopilot LNAV engage
wing_leveler_CMD = find_command("sim/autopilot/wing_leveler")
vertical_speed_pre_sel_CMD = find_command("sim/autopilot/vertical_speed_pre_sel")
vertical_speed_CMD = find_command("sim/autopilot/vertical_speed")
knotsmachtoggle_CMD = find_command("sim/autopilot/knots_mach_toggle")
autothrottle_off_CMD = find_command("sim/autopilot/autothrottle_off")
autothrottle_n1epr_CMD = find_command("sim/autopilot/autothrottle_n1epr")
glide_slope_CMD = find_command("sim/autopilot/glide_slope")
approach_CMD = find_command("sim/autopilot/approach")
level_change_CMD = find_command("sim/autopilot/level_change")
vnav_FMS_CMD = find_command("sim/autopilot/FMS")
altitude_hold_CMD = find_command("sim/autopilot/altitude_hold")
pitch_sync_CMD = find_command("sim/autopilot/pitch_sync")


------------------------------- COMMANDS: FUNCTIONS CALLBACK -------------------------------


-- FUNCTION: AUTOTHROTTLE SWITCH
function autothrottle_switch_funct(phase, duration)
	if phase == 0 then
		if autothrottle_switch == 0 then
			autothrottle_switch = 1
		else
			autothrottle_switch = 0
			autothrottle_enabled = 0
			autothrottle_off_CMD:once()
			fms_vnav = 0
		end
	end
end


-- FUNCTION: AIRSPEED IS KNOTS BUTTON
function airspeed_is_knots_funct(phase, duration)
	if phase == 0 then
		if airspeed_is_mach == 1 then
			knotsmachtoggle_CMD:once()
		end
		autothrottle_enabled = 1 --> SPEED MODE KT
		ats_epr_mode = 0
	end
end


-- FUNCTION: AIRSPEED IS MACH BUTTON
function airspeed_is_mach_funct(phase, duration)
	if phase == 0 then
		if airspeed_is_mach == 0 then
			knotsmachtoggle_CMD:once()
		end
		autothrottle_enabled = 1 --> SPEED MODE M
		ats_epr_mode = 1
	end
end


-- FUNCTION: EPR LIM BUTTON
function EPR_lim_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		if autothrottle_enabled ~= 2 then
			if autothrottle_switch == 1 and altitude_mode ~=3 and altitude_mode ~=5 and altitude_mode ~=10 then
				pitch_sync_CMD:once() turb_mode = 1 --> GO TO PITCH MODE TO ENABLE AT-EPR-MODE IF NOT ALREADY IN PITCH, IAS OR TOGA MODE
			end
			autothrottle_enabled = 2 --> EPR MODE
			--if ats_epr_mode < 2 then ats_epr_mode = 2 end
		end
	end
end



-- FUNCTION: AUTOLAND BUTTON
function autoland_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		fms_vnav = 0
		if approach_status == 0 then
			-- CHECK ALSO sim/cockpit2/autopilot/autopilot2_avail (0/1) ??????
			approach_CMD:once()
		end
		master_flight_director = 2
		if flight_director2_mode > 0 then flight_director2_mode = flight_director1_mode end --> PAIR BOTH FD		
	end
end


-- FUNCTION: VERT SPD (VVI) BUTTON
function vert_spd_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		fms_vnav = 0
		if glideslope_status > 0 then glide_slope_CMD:once() end --> ERASE GS MODE
		if altitude_mode ~= 4 then
			vertical_speed_CMD:once()
		end
	end
end


-- FUNCTION: IAS MACH (LEVEL CHANGE) BUTTON
function ias_mach_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		fms_vnav = 0
		if altitude_mode ~= 5 then
			if altitude_ft_pilot >= 27000 then
				airspeed_is_mach = 1
			else
				airspeed_is_mach = 0
			end
			level_change_CMD:once()
		elseif altitude_mode == 5 then
			--> FROM S TO M IF ALREDY IN S ABOVE 27K FEET
			knotsmachtoggle_CMD:once()
		end
	end
end


-- FUNCTION: VNAV BUTTON
function vnav_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		if fms_vnav == 0 and autothrottle_switch == 1 then vnav_FMS_CMD:once() end
	end
end


-- FUNCTION: ALT HOLD BUTTON
function alt_hold_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		fms_vnav = 0
		if altitude_mode ~= 6 then
			altitude_hold_CMD:once()
		end
	end
end


-- FUNCTION: TURB (PITCH) BUTTON
function turb_funct(phase, duration)
	if phase == 0 and flight_director_mode > 0 then
		fms_vnav = 0
		if altitude_mode ~= 3 and pitch_status ~= 2 then
			pitch_sync_CMD:once() --> SET PITCH SYNC MODE
			wing_leveler_CMD:once() --> SET ALSO WNG LVL MODE
			sync_hold_roll_deg = 0
			autothrottle_switch = 0 --> DISENGAGE ALSO AT
			turb_mode = 1
		end
	end
end


-- FUNCTIONS: PITCH WHEEL (REVERT TO VVI IF USED IN ALT OR VNAV MODE)
function wheel_before_func(phase, duration)
	if phase == 0 then
	end
end
function wheel_after_func(phase, duration)
	if phase == 0 then
		if altitude_mode == 6 or fms_vnav == 1 then vert_spd_CMD:once() end
	end
end


-- FUNCTIONS: *** THRUST RATING PANEL COMPUTER BUTTONS *** TO DO BETTER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function EPR_to_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		ats_epr_mode = 3
		autothrottle_EPR_limit = 1.55 -- red_hi_EPR-(oat_degc/100) --> SHOULD USE FORMULA ???????????????????????
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
	end
end
function EPR_toflex_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		ats_epr_mode = 2
		autothrottle_EPR_limit = red_hi_EPR-(autothrottle_EPR_assumed_temp/100) --> TO DO BETTER USING ALSO oat_degc ??????????????
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
	end
end
function EPR_ga_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		autothrottle_EPR_limit = 1.57 -- red_hi_EPR-(oat_degc/100) --> SHOULD USE FORMULA ???????????????????????
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
		ats_epr_mode = 4
	end
end
function EPR_mct_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		autothrottle_EPR_limit = 1.6
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
		ats_epr_mode = 5
	end
end
function EPR_cl_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		autothrottle_EPR_limit = 1.35
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
		ats_epr_mode = 6
	end
end
function EPR_cr_funct(phase, duration)
	if phase == 0 and avionics > 0 then
		autothrottle_EPR_limit = 1.25
		EPR_target_bug_L, EPR_target_bug_R = autothrottle_EPR_limit, autothrottle_EPR_limit
		ats_epr_mode = 7
	end
end


-- FUNCTION: HEADING PULL KNOB
function heading_dial_pull_funct(phase, duration)
	if phase == 0 then
		heading_dial = 2
		if heading_status ~= 2 then
			autopilot_HDG_CMD:once()
		end
	elseif phase == 2 then
		heading_dial = 0
	end
end


-- FUNCTION: ALTITUDE PULL KNOB
function alt_dial_pull_funct(phase, duration)
	if phase == 0 then
		alt_dial = 2
		-- FMS alt intervention
		if altitude_hold_status == 2 and fms_vnav == 1 then
			altitude_hold_CMD:once()
			fms_vnav = 1
		end
		-- everything else
		if altitude_hold_armed == 0 then
			autopilot_ALT_ARM_CMD:once()
		end
	elseif phase == 2 then
		alt_dial = 0
	end
end


-- FUNCTION: AP SOURCE 1-2 SWITCH
function source_nav_1_funct(phase, duration)
	if phase == 0 then
		autopilot_source_nav = 0
		master_flight_director = 0
		--autopilot_source = 0 --> pilot
		if flight_director2_mode == 2 then
			flight_director1_mode = 2
			flight_director2_mode = 1
		end
	end
end
function source_nav_2_funct(phase, duration)
	if phase == 0 then
		autopilot_source_nav = 1
		master_flight_director = 1
		--autopilot_source = 1 --> copilot
		if flight_director1_mode == 2 then
			flight_director2_mode = 2
			flight_director1_mode = 1
		end
	end
end


-- FUNCTION: AP MASTER SERVO SWITCH
function servos_master_toggle_funct(phase, duration)
	if phase == 0 then
		if master_flight_director == 0 then
			servos1_toggle_CMD:once()
		elseif master_flight_director == 1 then
			servos2_toggle_CMD:once()
		elseif master_flight_director == 2 then
			if flight_director1_mode == 2 or flight_director2_mode == 2 then
				flight_director1_mode = 1
				flight_director2_mode = 1
			else
				master_flight_director = 0
				autopilot_source_nav = 0
				servos1_toggle_CMD:once()
			end
		end
	end
end


------------------------------- COMMANDS: CREATE / WRAP -------------------------------

autothrottle_toggle_CMD = create_command("laminar/md82cmd/autopilot/autothrottle_switch","toggle autothrottle on/off",autothrottle_switch_funct)
airspeed_is_knots_CMD = create_command("laminar/md82cmd/autopilot/airspeed_is_knots","airspeed is knots",airspeed_is_knots_funct)
airspeed_is_mach_CMD = create_command("laminar/md82cmd/autopilot/airspeed_is_mach","airspeed is mach",airspeed_is_mach_funct)
heading_dial_pull_CMD = create_command("laminar/md82cmd/autopilot/heading_dial_pull","heading dial pull",heading_dial_pull_funct)
alt_dial_pull_CMD = create_command("laminar/md82cmd/autopilot/alt_dial_pull","alt dial pull",alt_dial_pull_funct)
source_nav_1_CMD = create_command("laminar/md82cmd/autopilot/source_1", "AP source 1", source_nav_1_funct)
source_nav_2_CMD = create_command("laminar/md82cmd/autopilot/source_2", "AP source 2", source_nav_2_funct)
servos_master_toggle_CMD = create_command("laminar/md82cmd/autopilot/servos_toggle", "AP servos toggle", servos_master_toggle_funct)

autoland_CMD = create_command("laminar/md82cmd/autopilot/autoland","autopilot autoland mode",autoland_funct)
vert_spd_CMD = create_command("laminar/md82cmd/autopilot/vert_spd","autopilot VVI mode",vert_spd_funct)
ias_mach_CMD = create_command("laminar/md82cmd/autopilot/ias_mach","autopilot airspeed mode (level change)",ias_mach_funct)
vnav_CMD = create_command("laminar/md82cmd/autopilot/vnav","autopilot FMS VNAV mode",vnav_funct)
alt_hold_CMD = create_command("laminar/md82cmd/autopilot/alt_hold","autopilot ALT hold mode",alt_hold_funct)
turb_CMD = create_command("laminar/md82cmd/autopilot/turb","autopilot TURB (pitch) mode",turb_funct)

EPR_lim_CMD = create_command("laminar/md82cmd/autopilot/EPR_lim","autothrottle EPR limits mode",EPR_lim_funct)
EPR_to_CMD = create_command("laminar/md82cmd/autopilot/EPR_TO","autothrottle EPR TO mode",EPR_to_funct)
EPR_toflex_CMD = create_command("laminar/md82cmd/autopilot/EPR_TOFLEX","autothrottle EPR TO FLEX mode",EPR_toflex_funct)
EPR_ga_CMD = create_command("laminar/md82cmd/autopilot/EPR_GA","autothrottle EPR GA mode",EPR_ga_funct)
EPR_mct_CMD = create_command("laminar/md82cmd/autopilot/EPR_MCT","autothrottle EPR MCT mode",EPR_mct_funct)
EPR_cl_CMD = create_command("laminar/md82cmd/autopilot/EPR_CL","autothrottle CL limits mode",EPR_cl_funct)
EPR_cr_CMD = create_command("laminar/md82cmd/autopilot/EPR_CR","autothrottle EPR CR mode",EPR_cr_funct)

wheel_down_CMD = wrap_command("sim/autopilot/nose_down",wheel_before_func,wheel_after_func)
wheel_up_CMD = wrap_command("sim/autopilot/nose_up",wheel_before_func,wheel_after_func)















--------------------------------- OTHER FUNCTIONS TO CALL BACK ---------------------------------

-- FUNCTION: RESET THE FMA
function reset_fma()
	--thr0 = ""
	--thr1 = ""
	arm0 = ""
	arm1 = ""
	rol0 = ""
	rol1 = ""
	pit0 = ""
	pit1 = ""
end

-- FUNCTION: TEST THE FMA
function test_fma()
	thr0 = "****"
	thr1 = "****"
	arm0 = "***"
	arm1 = "***"
	rol0 = "***"
	rol1 = "***"
	pit0 = "****"
	pit1 = "****"
end














-------------------------------------- RUNTIME CODE --------------------------------------


function flight_start()

	avionics = 0
	
	-- PAIR THE CUSTOM AUTOTHROTTLE DATAREF WITH THE XPLANE ONE
	if autothrottle_enabled > 0 then autothrottle_switch = 1 else autothrottle_switch = 0 end

	-- AUTOTHROTTLE EPR LIMITS
	autothrottle_EPR_assumed_temp = math.max(0,oat_degc)
	autothrottle_EPR_limit = 1.55
	EPR_target_bug_L = autothrottle_EPR_limit
	EPR_target_bug_R = autothrottle_EPR_limit
	ats_epr_mode = 0 --> 0=S, 1=M, EPR: 2=FLX, 3=TO, 4=GA, 5=MCT, 6=CL, 7=CR

	-- RESET FD MODE, SOURCES AND HSI
	flight_director_mode = 0
	master_flight_director = 0
	autopilot_source_nav = 0
	--autopilot_source = 0
	HSI_source_select_pilot = 0 --> HSI pilot side always to NAV1
	HSI_source_select_copilot = 1 --> HSI copilot side always to NAV2

	-- RESET THE FMA TO EMPTY EACH FLIGHT START
	reset_fma()

	-- SET MAX BANK ANGLE TO 30°
	bank_angle_mode = 6

	-- START THE PITCH PROFILE READOUT MODE TO VVI
	vvi_dial_fpm = 0
	vertical_speed_pre_sel_CMD:once()
	turb_mode = 0

	-- STARTUP RUNNING
	if startuprunning == 0 then
		flight_director1_mode = 0
		flight_director2_mode = 0
	else
		flight_director1_mode = 1
		flight_director2_mode = 1
	end

end


function after_physics()

	-- EVALUATE AVIONICS
	if (bus_volts_1 + bus_volts_2 > 0) then --> if some bus get power (from his engine, apu or gpu)
		avionics = 1
	else
		avionics = 0
	end
	
	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> FD MODE
	flight_director_mode = math.max(flight_director1_mode, flight_director2_mode) --> (0=off, 1=at least one to FD, 2=at least one to SERVOS ON)
	autopilot_switch = flight_director_mode
	copilot_heading_select = pilot_heading_select  -- always sync heading - otherwise flight director 2 doesn't know where to go in heading mode
	if gpss_status == 2 and master_flight_director ~= 0 then
		source_nav_1_CMD:once()
	end

	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> KEEP AUTOTHROTTLE OFF IF CUSTOM SWITCH OFF
	if autothrottle_switch == 0 and autothrottle_enabled > 0 then autothrottle_off_CMD:once() end


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> KEEP PAIRED CUSTOM SOURCE SWITCH TO INTERNAL MASTER FLGT DIR
	if master_flight_director < 2 and autopilot_source_nav ~= master_flight_director then autopilot_source_nav = master_flight_director end
	
	
	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> KEEP PAIRED PILOT AND COPILOT NAV2 OBS
	if nav2_obs_pilot ~= nav2_obs_copilot then nav2_obs_pilot = nav2_obs_copilot end --> NOT SURE IF USEFUL OR NOT


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> BAMK ANGLE LIMITS
	if bank_angle_mode < 2 then bank_angle_mode = 2 end --> make the bank mode never below 10°


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> KEEP PITCH ANGLE INTEGER OR .5
	sync_hold_diff = sync_hold_pitch_deg - math.floor(sync_hold_pitch_deg)
	if sync_hold_diff ~= 0 and sync_hold_diff ~= 0.5 then
		sync_hold_pitch_deg = sync_hold_pitch_deg - (0.5 - math.abs(sync_hold_diff))
	end
	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> KEEP ALSO AIRSPEED DIAL INTEGER
	--> NO NEED OF THIS if airspeed_is_mach == 0 then airspeed_dial_kts_mach = math.ceil(airspeed_dial_kts_mach) end


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> PITCH PROFILE READOUT UPDATE
	--> DISPLAY_MODE: 0=V(vvi) 1=S(ias) 2=M(mach) 3=P(pitch/turbulence) 4=/(none)
	--> ALTITUDE_MODE:3=pitch, 4=vvi, 5=speed, 6=alt via pitch
	if altitude_mode == 4 or altitude_mode == 6 then
		display_pitch_mode = 0
	elseif altitude_mode == 5 and airspeed_is_mach == 0 then
		display_pitch_mode = 1
	elseif altitude_mode == 5 and airspeed_is_mach == 1 then
		display_pitch_mode = 2
	elseif altitude_mode == 3 then
		display_pitch_mode = 3
	else
		--no change /// display_pitch_mode = 4
	end


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> EXTRA AND VARIOUS MODES ITERATIONS
	if altitude_mode ~= 3 then --> DISENGAGE SOFT RIDE (TURB) IF NOT IN PITCH MODE
		turb_mode = 0
	end

	if turb_mode == 0 and altitude_mode == 3 and pitch_status == 2 then --> REVERT TO VVI IF ONLY IN PITCH MODE (NOT TURB)
		display_pitch_mode = 0
		if flight_director_mode >= 1 then vertical_speed_pre_sel_CMD:once() end
	end

	if altitude_mode == 6 and altitude_hold_status == 2 then --> DISPLAY VVI 0 IF IN ALT HOLD MODE
		vvi_dial_fpm = 0
		display_pitch_mode = 0
	end


	------------------------------------------------------------------------------------>>>>>>>>>>>>>>>> UPDATE FMA CONDITIONS
	-- (AUTOTHROTTLE IS INDEPENDENT FROM FD)
		-- AUTOTHROTTLE/SPEED WINDOW
		if (autothrottle_enabled == 0) and (ats_epr_mode == 2) then
			thr0 = ""
			thr1 = string.sub("   "..math.ceil(autothrottle_EPR_assumed_temp), -4)
		elseif (autothrottle_enabled == 2) and (fms_vnav == 1) then
			thr0 = "FMS"
			thr1 = "EPR"
		elseif (autothrottle_enabled == 2) then -- and (ats_epr_mode >= 2) then
			thr0 = "EPR"
			if (ats_epr_mode < 2) then
				thr1 = "LIM"
			elseif (ats_epr_mode == 2) then
				thr1 = string.sub("   "..math.ceil(autothrottle_EPR_assumed_temp), -4)
			elseif (ats_epr_mode == 3) then
				thr1 = "T/O"
			elseif (ats_epr_mode == 4) then
				thr1 = "G/A"
			elseif (ats_epr_mode == 5) then
				thr1 = "MCT"
			elseif (ats_epr_mode == 6) then
				thr1 = "CL"
			elseif (ats_epr_mode == 7) then
				thr1 = "CR"
			end
		elseif (autothrottle_enabled == 0 and autothrottle_switch == 0) then
			thr0 = "ATS"
			thr1 = "OFF"
		elseif (autothrottle_enabled == 0 and autothrottle_switch == 1 and speed_status < 2) then
			thr0 = "CLMP"
			thr1 = ""
		elseif (autothrottle_enabled == 1) and (throttle_ratio_all < 0.01) then
			thr0 = "LOW"
			thr1 = "LIM"
		elseif (autothrottle_enabled == 1) and (airspeed_is_mach == 0) and (fms_vnav == 0) then
			thr0 = "SPD"
			thr1 = math.ceil(airspeed_dial_kts_mach)
		elseif (autothrottle_enabled == 1) and (airspeed_is_mach == 1) and (fms_vnav == 0)  then
			thr0 = "MACH"
			thr1 = "."..math.ceil(airspeed_dial_kts_mach*1000)
		elseif (autothrottle_enabled == 1) and (airspeed_is_mach == 0) and (fms_vnav == 1) then
			thr0 = "FMS"
			thr1 = "SPD"
		elseif (autothrottle_enabled == 1) and (airspeed_is_mach == 1) and (fms_vnav == 1)  then
			thr0 = "FMS"
			thr1 = "MACH"
		elseif (autothrottle_enabled == 3) or (autothrottle_switch == 1 and autothrottle_enabled == 0 and speed_status == 2) then
			thr0 = "RETD"
			thr1 = ""
		else
			thr0 = ""
			thr1 = ""
		end

	if flight_director_mode > 0 then ----> if FD or SERVOS are on
	
		-- ARMED WINDOW
		---------------------------------------------------------- first row:
		if (nav_status == 1) and (glideslope_status == 1) and (approach_status > 0) then
			arm0 = "ILS"
		elseif (nav_status == 1) and (glideslope_status ~= 1) and (approach_status > 0) then
			arm0 = "LOC"
		elseif (nav_status == 1) and (glideslope_status ~= 1) and (approach_status == 0) and (gpss_status == 0) then
			arm0 = "VOR"
		elseif (nav_status == 0) and (glideslope_status ~= 1) and (approach_status == 0) and (gpss_status == 1) then
			arm0 = "NAV"
		elseif (nav_status ~= 1) and (glideslope_status == 1) and (approach_status > 0) then
			arm0 = "G/S"
		elseif (nav_status > 0) and (glideslope_status > 0) and (approach_status > 0) and (flight_director2_mode+master_flight_director == 4) then
			arm0 = "LND"
		elseif (nav_status > 0) and (glideslope_status > 0) and (approach_status > 0) and (flight_director2_mode+master_flight_director < 4) and (flare_status == 0) then
			arm0 = "ILS"
		else
			arm0 = ""
		end
		---------------------------------------------------------- second row:
		if (altitude_hold_status == 1) or (altitude_hold_armed == 1) or (math.abs(altitude_hold_ft - altitude_dial_ft) > 99) then
			arm1 = string.sub("=="..altitude_dial_ft/100, -3) --> "ALT"
		else
			arm1 = ""
		end


		-- ROLL WINDOW
		if (roll_status > 0) and (heading_status == 0) and (nav_status < 2) and (gpss_status < 2) then
			rol0 = "WNG"
			rol1 = "LVL"
		elseif (roll_status == 0) and (heading_status > 0) then
			rol0 = "HDG"
			rol1 = "SEL"
		elseif (heading_status == 0) and (nav_status == 2) and (approach_status == 0) then
			rol0 = "VOR"
			rol1 = "TRK"
		elseif (heading_status == 0) and (nav_status == 2) and (approach_status > 0) then
			rol0 = "LOC"
			rol1 = "TRK"
		elseif (heading_status == 0) and (nav_status < 2) and (gpss_status == 2) then
			rol0 = "NAV"
			rol1 = "TRK"
		else
			rol0 = ""
			rol1 = ""
		end


		-- PITCH WINDOW
		if (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 0) and (speed_status == 2) and (airspeed_is_mach == 0) then
			pit0 = "IAS"
			pit1 = ""
		elseif (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 0) and (speed_status == 2) and (airspeed_is_mach == 1) then
			pit0 = "MACH"
			pit1 = ""
		elseif (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 1) and (speed_status == 2) then
			pit0 = "VNAV"
			pit1 = "CLB"
		elseif (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 0) and (glideslope_status < 2) and (altitude_hold_status == 2) then
			pit0 = "ALT"
			pit1 = "HLD"
		elseif (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 1) and (glideslope_status < 2) and (altitude_hold_status == 2) then
			pit0 = "VNAV"
			pit1 = "CRZ"
		elseif (pitch_status == 0) and (vvi_status == 0) and (fms_vnav == 0) and (glideslope_status == 2) and (altitude_hold_status < 2) then
			pit0 = "G/S"
			pit1 = "TRK"
		elseif (pitch_status > 0) and (vvi_status == 0) and (fms_vnav == 0) and (glideslope_status == 0) and (altitude_hold_status < 2) then
			pit0 = "TURB" --> BASICALLY THIS IS THE PITCH MODE
			pit1 = ""
		elseif (pitch_status == 0) and (vvi_status > 0) and (fms_vnav == 0) and (glideslope_status < 2) and (altitude_hold_status < 2) then
			pit0 = "VERT"
			pit1 = "SPD"
		elseif (pitch_status == 0) and (vvi_status > 0) and (fms_vnav == 1) and (glideslope_status < 2) and (altitude_hold_status < 2) then
			pit0 = "VNAV"
			pit1 = "DES"
		else
			pit0 = ""
			pit1 = ""
		end


		-- AUTOLAND MODE
		if (approach_status > 0) and (nav_status == 2) and (glideslope_status == 2) and (flare_status == 1) and (rollout_status == 1) then
		-- NO MORE: and (radio_alt_ft_pilot <= 1500) and (flap1_deploy_ratio >= 0.65)
				rol0 = "AUT"
				rol1 = "LND"
				pit0 = "AUT"
				pit1 = "LND"
		elseif (flare_status == 2) and (rollout_status == 1) then
				rol0 = "ALN"
				rol1 = ""
				pit0 = "FLAR"
				pit1 = ""
		elseif (flare_status == 2) and (rollout_status == 2) then
				rol0 = "ROL"
				rol1 = "OUT"
				pit0 = "ROL"
				pit1 = "OUT"
		end


		-- TOGA TAKE OFF OR GO AROUND MODE
		if (TOGA_status > 0) and (flap1_deploy_ratio > 0.25) and (flap1_deploy_ratio < 0.65) then
			TOGA_pitch_deg = 12.5
			if (TOGA_lateral_status > 0) then
				rol0 = "TAK"
				rol1 = "OFF"
			end
			pit0 = "TAK"
			pit1 = "OFF"
		elseif (TOGA_status > 0) and (flap1_deploy_ratio >= 0.65) then
			TOGA_pitch_deg = 10
			if (TOGA_lateral_status > 0) then
				rol0 = "GO"
				rol1 = "RND"
			end
			pit0 = "GO"
			pit1 = "RND"
		end


	else ---------------------------------> if FD or SERVOS are off

		-- SHUT OFF FMA WINDOWS
		reset_fma()

	end



	-- TEST BUTTON PRESSED
	if test_button == 1 then
		test_fma()
	end




end







