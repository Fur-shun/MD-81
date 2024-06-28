
----------------------------------- LOCATE OR CREATE DATAREFS -----------------------------------
APU_starter_switch = find_dataref("sim/cockpit2/electrical/APU_starter_switch") -- 0 is off, 1 is on, 2 is start-er-up!
APU_generator_amps = find_dataref("sim/cockpit2/electrical/APU_generator_amps")
APU_generator_on = find_dataref("sim/cockpit2/electrical/APU_generator_on")
APU_N1 = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
fuel_pump_spinning = find_dataref("sim/flightmodel2/engines/fuel_pump_spinning[0]")
battery_on = find_dataref("sim/cockpit2/electrical/battery_on[0]")
batteryEMER_on = find_dataref("sim/cockpit2/electrical/battery_on[1]")


------------------------------- FUNCTIONS: COMMANDS CALLBACK AND CREATION -------------------------------

-- ALLOW THE APU STARTER ONLY IF FUEL PUMP IS ALREADY SPINNING AND SOME BATTERY IS GIVING POWER

function APU_start(phase, duration)
	if phase == 0 then -- phase 0 mean switch first pressed
		if (fuel_pump_spinning > 0) and (battery_status > 0) then
			APU_starter_switch = 2
		else
			APU_starter_switch = 1
		end
	elseif phase == 2 then -- phase 2 mean switch released
		APU_starter_switch = 1
	end
end


cmdapustart = replace_command("sim/electrical/APU_start",APU_start)


----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	APU_generator_on = 1
end


-- REGULAR RUNTIME
function after_physics()
	battery_status = battery_on + batteryEMER_on
end


