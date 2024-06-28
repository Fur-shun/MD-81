
--
-- THIS SCRIPT DRIVE THE SPEED BUG ON THE ELECTRONIC PFD (Primary Flight Display)
-- THE ETA COMPUTATION ON THE ND (Navigation Display, BOTH PILOT/COPILOT)
-- THE ND MODE KNOB: ROSE, ARC (FOR VOR/ILS VISUALIZATION), NAV, PLAN (FOR FLIGHTPLAN VISUALIZATION)
-- THE MAP RANGE FROM 10 TO 320 (AVOIDING THE 640 nm)
-- AND PAIR VORs/NDBs TOGGLE VISUALIZATION ON EFIS MAP
--




------------------------------- FUNCTIONS -------------------------------

function nd_mode_func()
	-- FUNCTION FOR THE "MODE" CUSTOM WRITABLE DATAREF DRIVEN BY MANIPULATOR
	if nd_mode == 0 then -- ROSE
		map_mode = 1
		map_mode_is_HSI = 1
	elseif nd_mode == 1 then -- ARC
		map_mode = 1
		map_mode_is_HSI = 0
	elseif nd_mode == 2 then -- NAV
		map_mode = 2
	elseif nd_mode == 3 then -- PLAN
		map_mode = 4
	end
end

function cmd_EFIS_vor_func(phase, duration)
	-- KEEP PAIRED VORs/NDBs VISUALIZATION ON MOVING MAP
	if phase == 0 then
		EFIS_vor_on = math.abs(EFIS_vor_on - 1) -- toggle from 0 and 1
		EFIS_ndb_on = math.abs(EFIS_ndb_on - 1) -- toggle from 0 and 1
	end
end

function cmd_mapzoomout_func()
	-- AVOIDING THE 640 nm FOR MAP ZOOM OUT
	if map_range > 5 then
		map_range = 5
	end
end



----------------------------------- DATAREFS: LOCATE -----------------------------------

airspeed_is_mach = find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
airspeed_dial_kts_mach = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
airspeed_dial_kts = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")
airspeed_kts_pilot = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
--tas_kts_pilot = find_dataref("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
--airspeed_machno = find_dataref("sim/flightmodel/misc/machno")
airspeed_machno = find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
gps_dme_time_min = find_dataref("sim/cockpit2/radios/indicators/gps_dme_time_min")
zulu_time_sec = find_dataref("sim/time/zulu_time_sec")
map_mode = find_dataref("sim/cockpit2/EFIS/map_mode") --> 0=app, 1=vor, 2=map, 3=nav, 4=plan
map_mode_is_HSI = find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI") --> 0=arc, 1=rose
map_range = find_dataref("sim/cockpit2/EFIS/map_range") --> from 0 to 6 in nautical miles: 10,20,40,80,160,320,640 for big map (use EFIS/but_map_zoom.png button in the 2d panel)
EFIS_vor_on = find_dataref("sim/cockpit2/EFIS/EFIS_vor_on")
EFIS_ndb_on = find_dataref("sim/cockpit2/EFIS/EFIS_ndb_on")







----------------------------------- DATAREFS: CREATE -----------------------------------

speed_bug = create_dataref("laminar/md82/PFD/speed_bug","number")
time_ETA = create_dataref("laminar/md82/ND/time_ETA","number")
nd_mode = create_dataref("laminar/md82/ND/mode","number",nd_mode_func) --> 0=rose, 1=arc, 2=nav, 3=plan (driven by manipulator)





----------------------------------- COMMANDS -----------------------------------

replace_command("sim/instruments/EFIS_vor",cmd_EFIS_vor_func)
wrap_command("sim/instruments/map_zoom_out",cmd_mapzoomout_func,cmd_mapzoomout_func)






-------------------------------------- RUNTIME CODE --------------------------------------

function flight_start()

	speed_bug = 0
	ETE_tot_sec = 0
	ETA_tot_sec = 0
	ETA_hrs = 0
	ETA_min = 0
	ETA_sec = 0
	map_mode = 1
	map_mode_is_HSI = 1
	map_range = 2
	nd_mode = 0
	
end


function after_physics()

	--->>>>>>>>>>>>>>>> PFD STUFF
	-- EVALUATE SPEED BUG - positive value means bug toward Fast, negative toward Slow
	if (airspeed_is_mach == 0) then
		speed_bug = (airspeed_kts_pilot/10) - (airspeed_dial_kts_mach/10)
	else
		speed_bug = (airspeed_machno*10) - (airspeed_dial_kts_mach*10)
	end
	
	--->>>>>>>>>>>>>>>> ND STUFF
	-- COMPUTE ETA
	ETE_tot_sec = gps_dme_time_min * 60
	ETA_tot_sec = zulu_time_sec + ETE_tot_sec
	ETA_hrs = math.floor(ETA_tot_sec / 3600)
	ETA_min = math.floor((ETA_tot_sec % 3600) / 60)
	ETA_sec = math.floor((ETA_tot_sec % 3600) % 60)
	time_ETA = (ETA_hrs * 100) + ETA_min + (ETA_sec / 60) --> THIS OUTPUT TIME IN THE FORM HHMM.SS (tenth of a minute to next waypoint)	

end
