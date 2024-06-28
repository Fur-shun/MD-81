--
-- THIS SCRIPT SIMULATE THE SELECTION OF THE IGNITION SYSTEM
-- BY LET MOVING THE KNOB ON THE OVERHEAD, BUT IN FACT THAT KNOB DOES NOTHING
-- (0=off, 1=sysA, 2=sysB, 3=both, 4=ovrd)
--
-- THE SCRIPT ALSO KEEP AUTOMATICALLY THE STARTER RUNNING FOR A CERTAIN AMOUNT OF TIME
-- TO HELP USER OPEN FUEL DURING THE STARTUP
--



----------------------------------- LOCATE AND CREATE DATAREFS OR COMMANDS -----------------------------------

ignition_keyL = find_dataref("sim/cockpit2/engine/actuators/ignition_key[0]") -- 0=off, 1=left, 2=right, 3=both, 4=starting
ignition_keyR = find_dataref("sim/cockpit2/engine/actuators/ignition_key[1]") -- 0=off, 1=left, 2=right, 3=both, 4=starting

ignitionsysKNOB = create_dataref("laminar/md82/ignition_sys","number") -- the position of the ignition system knob







------------------------------- FUNCTIONS: COMMANDS CALLBACK AND CREATION -------------------------------


-- KEEP THE STARTERS PRESSED FUNCTIONS
function starterL_cmd_before(phase, duration)
end
function starterL_off()
	keep_ignition_L = 0
end
function starterL_cmd_after(phase, duration)
	if phase == 2 and duration > 2.5 then -- keep starter running if button was held down more than 2.5 sec
		keep_ignition_L = 1
		run_after_time(starterL_off, 6) -- turn starter off after 6 sec
	end
end

function starterR_cmd_before(phase, duration)
end
function starterR_off()
	keep_ignition_R = 0
end
function starterR_cmd_after(phase, duration)
	if phase == 2 and duration > 2.5 then -- keep starter running if button was held down more than 2.5 sec
		keep_ignition_R = 1
		run_after_time(starterR_off, 6) -- turn starter off after 6 sec
	end
end


starterL_cmd = wrap_command("sim/starters/engage_starter_1",starterL_cmd_before,starterL_cmd_after)
starterR_cmd = wrap_command("sim/starters/engage_starter_2",starterR_cmd_before,starterR_cmd_after)







-- IGNITION KNOB SYS FUNCTIONS
function ignitionsys_up(phase, duration)
	if phase == 0 then
		if (ignitionsysKNOB == 2) or (ignitionsysKNOB == 3) then
			ignitionsysKNOB = ignitionsysKNOB + 1
		elseif (ignitionsysKNOB == 1) then
			ignitionsysKNOB = 0
		elseif (ignitionsysKNOB == 0) then
			ignitionsysKNOB = 2
		else
			ignitionsysKNOB = 4
		end
	end
end

function ignitionsys_dwn(phase, duration)
	if phase == 0 then
		if (ignitionsysKNOB == 4) or (ignitionsysKNOB == 3) then
			ignitionsysKNOB = ignitionsysKNOB - 1
		elseif (ignitionsysKNOB == 2) then
			ignitionsysKNOB = 0
		elseif (ignitionsysKNOB == 0) then
			ignitionsysKNOB = 1
		else
			ignitionsysKNOB = 1
		end
	end
end


cmdignitionsys_up = create_command("laminar/md82cmd/ignition_sys_up","ignition system selection up one",ignitionsys_up)
cmdignitionsys_dwn = create_command("laminar/md82cmd/ignition_sys_dwn","ignition system selection down one",ignitionsys_dwn)









----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	ignitionsysKNOB = 0
end




-- REGULAR RUNTIME
function after_physics()

	-- KEEP IGNITION KEY PRESSED OR NOT
	if keep_ignition_L == 1 then
		ignition_keyL = 4
	else
		ignition_keyL = 0
	end
	if keep_ignition_R == 1 then
		ignition_keyR = 4
	else
		ignition_keyR = 0
	end

end


