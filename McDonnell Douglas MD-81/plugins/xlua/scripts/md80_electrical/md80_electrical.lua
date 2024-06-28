
-- OKAY, XPLANE ACTUALLY HAS JUST ONE CROSS-TIE OPTION: ALL BUSES TIED TOGHETER OR NOT,
-- SO HERE WE CONTROL WHEN TIE-ALL-BUSES OR NOT FROM CUSTOM OVERHEAD SWITCHES POSITIONS.
-- BUS[0] IS THE DEFAULT APU/GPU BUS (uneditable) AND ALSO THE BATTERY AND EMERGENCY BUS,
-- BUS[1] AND [2] ARE THE L AND R BUSES (see Plane-Maker system window for details).
-- INVERTERS WILL BE TURNED ON WHEN APU OR ENGINES ARE ON.
-- AVIONICS WILL ALSO BE TURNED ON WHEN BUSES GET POWER.

-- THIS SCRIPT DRIVE ALSO THE VOLTMETER MULTI-SELECTION KNOB WITH RELATED NEEDLES,
-- AND EVALUATE GENERATORS AMPS FOR THE "ELECTRICAL FLASHING" EFFECT.



----------------------------------- LOCATE AND CREATE DATAREFS -----------------------------------

cross_tie = find_dataref("sim/cockpit2/electrical/cross_tie")
avionics = find_dataref("sim/cockpit2/switches/avionics_power_on")
emerg_battery_on = find_dataref("sim/cockpit2/electrical/battery_on[1]") -- emerg battery
APU_N1 = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
GPU_on = find_dataref("sim/cockpit/electrical/gpu_on")
inverterL = find_dataref("sim/cockpit2/electrical/inverter_on[0]")
inverterR = find_dataref("sim/cockpit2/electrical/inverter_on[1]")
engineL_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
engineR_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")

bus_volts_0 = find_dataref("sim/cockpit2/electrical/bus_volts[0]")
bus_amps_0 = find_dataref("sim/cockpit2/electrical/bus_load_amps[0]")
bus_volts_1 = find_dataref("sim/cockpit2/electrical/bus_volts[1]")
bus_amps_1 = find_dataref("sim/cockpit2/electrical/bus_load_amps[1]")
bus_volts_2 = find_dataref("sim/cockpit2/electrical/bus_volts[2]")
bus_amps_2 = find_dataref("sim/cockpit2/electrical/bus_load_amps[2]")

gen_amps_L = find_dataref("sim/cockpit2/electrical/generator_amps[0]") -- L engine gen amps
gen_amps_R = find_dataref("sim/cockpit2/electrical/generator_amps[1]") -- R engine gen amps

rel_esys1 = find_dataref("sim/operation/failures/rel_esys") -- bus0 0= working 6=fail
rel_esys2 = find_dataref("sim/operation/failures/rel_esys2") -- bus1
rel_esys3 = find_dataref("sim/operation/failures/rel_esys3") -- bus2

cross_tie_APU_L = create_dataref("laminar/md82/electrical/cross_tie_APU_L","number")
cross_tie_APU_R = create_dataref("laminar/md82/electrical/cross_tie_APU_R","number")
cross_tie_GPU_L = create_dataref("laminar/md82/electrical/cross_tie_GPU_L","number")
cross_tie_GPU_R = create_dataref("laminar/md82/electrical/cross_tie_GPU_R","number")
cross_tie_AC = create_dataref("laminar/md82/electrical/cross_tie_AC","number")
cross_tie_DC = create_dataref("laminar/md82/electrical/cross_tie_DC","number")

voltmeter_source = create_dataref("laminar/md82/electrical/voltmeter_source","number") --> (0=APU, 1=GPU, 2=busL, 3=busR, 4=battVOLTS, 5=battAMPS)
volt_amp_needle = create_dataref("laminar/md82/electrical/volt_amp_needle","number") --> (from -1 to +1)
AC_volts_needle = create_dataref("laminar/md82/electrical/AC_volts_needle","number") --> (from 50 to 150, 115 nominal)
freq_cps_needle = create_dataref("laminar/md82/electrical/freq_cps_needle","number") --> (from 380 to 420)







gen_amps_L_before = 0
gen_amps_R_before = 0



------------------------------- FUNCTIONS -------------------------------

-- ANIMATION OF THE VOLTMETER NEEDLES
function update_voltmeter_needles()
	volt_amp_needle = volt_amp_needle + ((volt_amp_needleNEW - volt_amp_needle) * (10 * SIM_PERIOD))
	AC_volts_needle = AC_volts_needle + ((AC_volts_needleNEW - AC_volts_needle) * (10 * SIM_PERIOD))
	freq_cps_needle = freq_cps_needle + ((freq_cps_needleNEW - freq_cps_needle) * (10 * SIM_PERIOD))
end


-- ELECTRICAL FLASHING EFFECT FUNCTIONS
function flashing_reset()
	rel_esys1,rel_esys2,rel_esys3 = 0,0,0
end

function flashing_effect()
	rel_esys1,rel_esys2,rel_esys3 = 0,6,6
	run_after_time(flashing_reset,0.1)
end









------------------------------- FUNCTIONS: COMMANDS CALLBACK -------------------------------

-- TOGGLE APU AND GPU SWITCHES ON / OFF
function cmd_cross_tie_APU_L(phase, duration)
	if phase == 0 then
		cross_tie_APU_L = math.abs((cross_tie_APU_L + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end

function cmd_cross_tie_APU_R(phase, duration)
	if phase == 0 then
		cross_tie_APU_R = math.abs((cross_tie_APU_R + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end

function cmd_cross_tie_GPU_L(phase, duration)
	if phase == 0 then
		cross_tie_GPU_L = math.abs((cross_tie_GPU_L + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end

function cmd_cross_tie_GPU_R(phase, duration)
	if phase == 0 then
		cross_tie_GPU_R = math.abs((cross_tie_GPU_R + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end

function cmd_cross_tie_AC(phase, duration)
	if phase == 0 then
		cross_tie_AC = math.abs((cross_tie_AC + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end

function cmd_cross_tie_DC(phase, duration)
	if phase == 0 then
		cross_tie_DC = math.abs((cross_tie_DC + 1) - 2) -- inverte da 0 a 1 e viceversa
	end
end


-- VOLTMETER SOURCE KNOB UP OR DOWN ONE POSITION
function cmd_voltmeter_up(phase, duration)
	if phase == 0 then
		if (voltmeter_source < 5) then
			voltmeter_source = voltmeter_source + 1
		else
			voltmeter_source = 0
		end
	end
end

function cmd_voltmeter_dwn(phase, duration)
	if phase == 0 then
		if (voltmeter_source > 0) then
			voltmeter_source = voltmeter_source - 1
		else
			voltmeter_source = 5
		end
	end
end


------------------------------- COMMANDS CREATION -------------------------------

cmdAPUL = create_command("laminar/md82cmd/electrical/cross_tie_APU_L","toggle APU tie L button",cmd_cross_tie_APU_L)
cmdAPUR = create_command("laminar/md82cmd/electrical/cross_tie_APU_R","toggle APU tie R button",cmd_cross_tie_APU_R)
cmdGPUL = create_command("laminar/md82cmd/electrical/cross_tie_GPU_L","toggle GPU tie L button",cmd_cross_tie_GPU_L)
cmdGPUR = create_command("laminar/md82cmd/electrical/cross_tie_GPU_R","toggle GPU tie R button",cmd_cross_tie_GPU_R)
cmdAC = create_command("laminar/md82cmd/electrical/cross_tie_AC","toggle AC tie button",cmd_cross_tie_AC)
cmdDC = create_command("laminar/md82cmd/electrical/cross_tie_DC","toggle DC tie button",cmd_cross_tie_DC)

cmdVOLTMETERup = create_command("laminar/md82cmd/electrical/voltmeter_source_up","voltmeter knob up one",cmd_voltmeter_up)
cmdVOLTMETERdwn = create_command("laminar/md82cmd/electrical/voltmeter_source_dwn","voltmeter knob dwn one",cmd_voltmeter_dwn)













----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
function flight_start()
	-- none
end




-- REGULAR RUNTIME
function after_physics()


	-- EVALUATE APU AND GPU TO SET THE CROSS-TIE ON OR OFF
	tieAPU = (cross_tie_APU_L + cross_tie_APU_R)
	tieGPU = (cross_tie_GPU_L + cross_tie_GPU_R)

	if (APU_N1 > 95) and (tieAPU > 0) then
		APUtied = 1
	else
		APUtied = 0
	end

	if (GPU_on == 1) and (tieGPU > 0) then
		GPUtied = 1
	else
		GPUtied = 0
	end

	if (APUtied > 0) or (GPUtied > 0) then --> if apu or gpu have power and are tied
		cross_tie = 1
	else
		cross_tie = 0
	end


	-- EVALUATE THE AC/DC SWITCHES
	if (engineL_on + engineR_on > 0) and (APUtied + GPUtied == 0) then
		if (cross_tie_AC + cross_tie_DC > 0) then
			cross_tie = 1
		else
			cross_tie = 0
		end
	end


	-- EVALUATE FOR AVIONICS
	if (bus_volts_1 > 0) or (bus_volts_2 > 0) then --> if some bus get power (from his engine, apu or gpu)
		avionics = 1
	else
		avionics = 0
	end


	-- EVALUATE FOR INVERTERS
	if (engineL_on > 0) or (APU_N1 > 95) or (GPUtied == 1) then
		inverterL = 1
	else
		inverterL = 0
	end
	if (engineR_on > 0) or (APU_N1 > 95) or (GPUtied == 1) then
		inverterR = 1
	else
		inverterR = 0
	end


	-- EVALUATE FOR EMERGENCY POWER: CROSS-TIE AND INVERTERS ON
	if emerg_battery_on == 1 then
		cross_tie = 1
		inverterL , inverterR = 1 , 1
	else
		-- none: let the previous part of this script do the job
	end


	-- SET VOLTMETER NEEDLES ACCORDING TO VOLTMETER KNOB POSITION
	if (voltmeter_source == 0) then ------ APU
		volt_amp_needleNEW = 0
		AC_volts_needleNEW = APU_N1 * 1.15
		freq_cps_needleNEW = APU_N1 * 4
	elseif (voltmeter_source == 1) then ------ GPU
		volt_amp_needleNEW = 0
		AC_volts_needleNEW = GPU_on * 115
		freq_cps_needleNEW = GPU_on * 400
	elseif (voltmeter_source == 2) then ------ L BUS
		volt_amp_needleNEW = bus_volts_1 * 0.026
		AC_volts_needleNEW = bus_volts_1 * 4.1
		freq_cps_needleNEW = bus_volts_1 * 14.3
	elseif (voltmeter_source == 3) then ------ R BUS
		volt_amp_needleNEW = bus_volts_2 * 0.026
		AC_volts_needleNEW = bus_volts_2 * 4.1
		freq_cps_needleNEW = bus_volts_2 * 14.3
	elseif (voltmeter_source == 4) then ------ BATT VOLTS
		volt_amp_needleNEW = bus_volts_0 * 0.026
		AC_volts_needleNEW = 0
		freq_cps_needleNEW = 0
	elseif (voltmeter_source == 5) then ------ BATT AMPS
		volt_amp_needleNEW = bus_amps_0 / 100
		AC_volts_needleNEW = 0
		freq_cps_needleNEW = 0
	else
		volt_amp_needleNEW = 0
		AC_volts_needleNEW = 0
		freq_cps_needleNEW = 0
	end
	update_voltmeter_needles()


	-- EVALUATE GENERATORS AMPS FOR THE "ELECTRICAL FLASHING" EFFECT
	if gen_amps_L_before == 0 and gen_amps_L > 0 --[[or gen_amps_L_before > 0 and gen_amps_L == 0--]] then flashing_effect() end
	if gen_amps_R_before == 0 and gen_amps_R > 0 --[[or gen_amps_R_before > 0 and gen_amps_R == 0--]] then flashing_effect() end
	gen_amps_L_before = gen_amps_L
	gen_amps_R_before = gen_amps_R


end











