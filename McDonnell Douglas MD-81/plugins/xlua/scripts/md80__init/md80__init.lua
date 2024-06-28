----------------------------------- MD80 SYSTEMS INITIALIZATION -----------------------------------
-- this script is here to initialize some values



----------------------------------- LOCATE DATAREFS OR COMMANDS -----------------------------------
startuprunning = find_dataref("sim/operation/prefs/startup_running")
batteryEMERG = find_dataref("sim/cockpit2/electrical/battery_on[1]")
fuelpumpC = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
fuelpumpL = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
fuelpumpR = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")
fuel_selectorL = find_dataref("sim/cockpit2/fuel/fuel_tank_selector_left")
fuel_selectorR = find_dataref("sim/cockpit2/fuel/fuel_tank_selector_right")
-- generatorAPU = find_dataref("sim/cockpit2/electrical/APU_generator_on") -- DISABLED: controlled by the apu script
-- avionics = find_dataref("sim/cockpit2/switches/avionics_power_on") -- DISABLED: controlled by the electrical script
gyr_spin_ahrs1 = find_dataref("sim/cockpit/gyros/gyr_spin[0]") --> 0=ahrs1,1=ahrs2,2=elec1,3=elec2,4=vac1,5=vac2
speedbrake_ratio = find_dataref("sim/cockpit2/controls/speedbrake_ratio") --> -0.5 armed, 0 retracted, 1 fully extended
cross_tie_AC = find_dataref("laminar/md82/electrical/cross_tie_AC")
cross_tie_DC = find_dataref("laminar/md82/electrical/cross_tie_DC")
-- flight_director1_mode = find_dataref("sim/cockpit2/autopilot/flight_director_mode") --> 0 is off, 1 is on, 2 is on with servos
-- flight_director2_mode = find_dataref("sim/cockpit2/autopilot/flight_director2_mode")





--------------------------------- CREATING FUNCTIONS TO CALL BACK ---------------------------------

-- NONE




--------------------------------- DO THIS EACH FLIGHT START ---------------------------------
function flight_start()
	fuel_selectorL = 4
	fuel_selectorR = 4
	if startuprunning == 0 then
		batteryEMERG = 0
		fuelpumpC = 0
		fuelpumpL = 0
		fuelpumpR = 0
		-- generatorAPU = 0
		-- avionics = 0
		gyr_spin_ahrs1 = 0
	else
		batteryEMERG = 0
		fuelpumpC = 1
		fuelpumpL = 1
		fuelpumpR = 1
		-- generatorAPU = 1
		-- avionics = 1
		gyr_spin_ahrs1 = 1
		cross_tie_AC = 1
		cross_tie_DC = 1
	end
end



--------------------------------- RUNTIME ---------------------------------
function after_physics()
	-- none
end


