
--------------------------------------------------------------
-- DEALING WITH FLIGHT CONTROLS:
--
-- SPEEDBRAKES AND FLAPS CUSTOM DETENTS DATAREFS
-- LANDING GEAR CUSTOM DATAREF
-- LONG TRIM CUSTOM DATAREF
--------------------------------------------------------------




------------------------------- FUNCTIONS -------------------------------

-- ANIMATION OF THE GEAR HANDLE
function update_gear_handle()
	landing_gear_handle = landing_gear_handle + ((gear_handle_down - landing_gear_handle) * (10 * SIM_PERIOD))
end

-- ANIMATION OF THE TRIM HANDLE
function update_trim_handle()
	elevator_trim_handle = elevator_trim_handle + ((trim_handle_target - elevator_trim_handle) * (10 * SIM_PERIOD))
end



------------------------------- FUNCTIONS FOR WRITABLE DATAREFS -------------------------------

function speedbrake_detents_func()
	-- do nothing
end

function flap_detents_func()
	-- do nothing
end


function landing_gear_handle_func()

	if landing_gear_handle > 0 and landing_gear_handle < 0.5 then
		gear_handle_down = 0
	elseif landing_gear_handle > 0.5 and landing_gear_handle < 1 then
		gear_handle_down = 1
	end

end


function elevator_trim_handle_func()

	if elevator_trim_handle < -0.1 then
		cmd_pitch_trim_down:once()
	elseif elevator_trim_handle > 0.1 then
		cmd_pitch_trim_up:once()
	end

end



----------------------------------- LOCATE OR CREATE DATAREFS AND COMMANDS -----------------------------------

cmd_pitch_trim_down = find_command("sim/flight_controls/pitch_trim_down")
cmd_pitch_trim_up = find_command("sim/flight_controls/pitch_trim_up")

speedbrake_ratio = find_dataref("sim/cockpit2/controls/speedbrake_ratio") --> -0.5 auto-spdbrk armed, 0 retracted, 1 fully extended
gear_handle_down = find_dataref("sim/cockpit2/controls/gear_handle_down") --> landing gear request: 0 up, 1 down
elevator_trim = find_dataref("sim/cockpit2/controls/elevator_trim") --> elev trim ratio: -1=down, 1=up
autopilot_switch = find_dataref("laminar/md82/autopilot/autopilot_switch") --> custom AP switch 0=off, 1=on

speedbrake_detents = create_dataref("laminar/md82/controls/speedbrake_detents","number",speedbrake_detents_func) --> the lift amount of the handle, used by the cockpit manipulator
flap_detents = create_dataref("laminar/md82/controls/flap_detents","number",flap_detents_func) --> the lift amount of the handle, used by the cockpit manipulator
landing_gear_handle = create_dataref("laminar/md82/controls/landing_gear_handle","number",landing_gear_handle_func) --> the custom handle used by the cockpit manipulator
elevator_trim_handle = create_dataref("laminar/md82/controls/elevator_trim_handle","number",elevator_trim_handle_func) --> the custom handle used by the cockpit manipulator



--------------------------------- RUNTIME ---------------------------------

-- DO THIS EACH FLIGHT START
function flight_start()
	speedbrake_detents = speedbrake_ratio
	landing_gear_handle = gear_handle_down
end

-- INIT VAR
current_trim = elevator_trim

-- REGULAR RUNTIME
function after_physics()

	-- SPEEDBRAKES
	-- KEEP THE CUSTOM SPEEDBRAKE LIFT SYNC WITH THE ACTUAL XPLANE ONE
	if speedbrake_ratio == -0.5 then speedbrake_detents = 1 end
	if speedbrake_ratio == 0 then speedbrake_detents = 0 end
	if speedbrake_ratio == 0.5 then speedbrake_detents = 0 end
	if speedbrake_ratio == 1 then speedbrake_detents = 0 end

	-- LANDING GEAR
	-- KEEP THE CUSTOM LAND GEAR POSITION SYNC WITH THE ACTUAL XPLANE ONE
	if landing_gear_handle ~= gear_handle_down then update_gear_handle() end


	-- ELEVATOR TRIM
	-- KEEP THE CUSTOM ELEVATOR TRIM SYNC WITH THE ACTUAL XPLANE ONE
	if autopilot_switch < 2 then --> DO ONLY IF THE AP IS NOT CONTROLLING TRIM
		new_trim = elevator_trim
		if new_trim < current_trim then
			trim_handle_target = -0.5
			update_trim_handle()
		elseif new_trim > current_trim then
			trim_handle_target = 0.5
			update_trim_handle()
		end
		current_trim = elevator_trim
	end
	-- SPRING OF THE TRIM HANDLE TO ZERO IF NOT MOVED
	if elevator_trim_handle ~= 0 then trim_handle_target = 0 update_trim_handle() end

end


