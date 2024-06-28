
----------------------------------- LOCATE AND CREATE DATAREFS -----------------------------------
pitotPILOT = find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_pilot")
pitotCOPILOT = find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_copilot")
stallPILOT = find_dataref("sim/cockpit2/ice/ice_AOA_heat_on")
stallCOPILOT = find_dataref("sim/cockpit2/ice/ice_AOA_heat_on_copilot")
busVOLTS = find_dataref("sim/cockpit2/electrical/bus_volts[0]")

heatmeter = create_dataref("laminar/md82/ice/heatmeter","number") -- the needle of the electric flow meter
selheatKNOB = create_dataref("laminar/md82/ice/heatknob","number") -- the position of the sel&heat knob








------------------------------- FUNCTIONS -------------------------------

-- ANIMATION OF THE HEADMETER NEEDLE
function update_heat_meter_needle()
	heatmeter = heatmeter + ((heatmeterNEW - heatmeter) * (10 * SIM_PERIOD))
end






------------------------------- FUNCTIONS: COMMANDS CALLBACK AND CREATION -------------------------------

function heating_meter_up(phase, duration)
	if phase == 0 then
		if (selheatKNOB < 9) then
			selheatKNOB = selheatKNOB + 1
			heatmeterNEW = 5 - (math.random()/2)
		else
			selheatKNOB = 0
			heatmeterNEW = 0
		end
	end
end

function heating_meter_dwn(phase, duration)
	if phase == 0 then
		if (selheatKNOB > 0) then
			selheatKNOB = selheatKNOB - 1
			heatmeterNEW = 5 - (math.random()/2)
		else
			selheatKNOB = 9
			heatmeterNEW = 5 - (math.random()/2)
		end
	end
end

cmd1 = create_command("laminar/md82cmd/ice/selheatknob_up","heating and meter selection up one",heating_meter_up)
cmd2 = create_command("laminar/md82cmd/ice/selheatknob_dwn","heating and meter selection down one",heating_meter_dwn)









----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	heatmeter = 0
	selheatKNOB = 0
end




-- REGULAR RUNTIME
function after_physics()

	-- ACTIVATE OR DEACTIVATE ALL PITOT/STALL HEATING DEPENDING FROM selheatKNOB POSITION
	-- PLUS SET THE VALUE FOR THE METER NEEDLE
	if (selheatKNOB > 0) and (selheatKNOB < 10) and (busVOLTS > 0) then
		pitotPILOT = 1
		pitotCOPILOT = 1
		stallPILOT = 1
		stallCOPILOT = 1
		update_heat_meter_needle()
	else
		pitotPILOT = 0
		pitotCOPILOT = 0
		stallPILOT = 0
		stallCOPILOT = 0
		heatmeterNEW = 0
		update_heat_meter_needle()
	end
end


