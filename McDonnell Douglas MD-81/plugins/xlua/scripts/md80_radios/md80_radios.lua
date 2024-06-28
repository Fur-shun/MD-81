
--
-- THIS SCRIPT DEALS WITH FREQUENCIES, RADIO KNOBS AND SWITCHES
--


----------------------------------- LOCATE AND CREATE DATAREFS -----------------------------------
com1_left_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/com1_left_frequency_hz")
com1_right_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/com1_right_frequency_hz")
com2_left_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/com2_left_frequency_hz")
com2_right_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/com2_right_frequency_hz")

adf1_left_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/adf1_left_frequency_hz")
adf1_right_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/adf1_right_frequency_hz")
adf2_left_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/adf2_left_frequency_hz")
adf2_right_frequency_hz = find_dataref("sim/cockpit2/radios/actuators/adf2_right_frequency_hz")



------------------------------- FUNCTIONS -------------------------------
--none




------------------------------- FUNCTIONS: COMMANDS CALLBACK -------------------------------

----------------------------------------
-- COM1 LEFT -- FINE AND COARSE KNOBS --
----------------------------------------
function com1_left_fine_up_FNCT(phase, duration)
	if phase == 0 then	com1_left_frequency_hz = com1_left_frequency_hz + 2.5		end
end

function com1_left_fine_dwn_FNCT(phase, duration)
	if phase == 0 then	com1_left_frequency_hz = com1_left_frequency_hz - 2.5		end
end

function com1_left_coarse_up_FNCT(phase, duration)
	if phase == 0 then	com1_left_frequency_hz = com1_left_frequency_hz + 100		end
end

function com1_left_coarse_dwn_FNCT(phase, duration)
	if phase == 0 then	com1_left_frequency_hz = com1_left_frequency_hz - 100		end
end

-----------------------------------------
-- COM1 RIGHT -- FINE AND COARSE KNOBS --
-----------------------------------------
function com1_right_fine_up_FNCT(phase, duration)
	if phase == 0 then	com1_right_frequency_hz = com1_right_frequency_hz + 2.5		end
end

function com1_right_fine_dwn_FNCT(phase, duration)
	if phase == 0 then	com1_right_frequency_hz = com1_right_frequency_hz - 2.5		end
end

function com1_right_coarse_up_FNCT(phase, duration)
	if phase == 0 then	com1_right_frequency_hz = com1_right_frequency_hz + 100		end
end

function com1_right_coarse_dwn_FNCT(phase, duration)
	if phase == 0 then	com1_right_frequency_hz = com1_right_frequency_hz - 100		end
end

----------------------------------------
-- COM2 LEFT -- FINE AND COARSE KNOBS --
----------------------------------------
function com2_left_fine_up_FNCT(phase, duration)
	if phase == 0 then	com2_left_frequency_hz = com2_left_frequency_hz + 2.5		end
end

function com2_left_fine_dwn_FNCT(phase, duration)
	if phase == 0 then	com2_left_frequency_hz = com2_left_frequency_hz - 2.5		end
end

function com2_left_coarse_up_FNCT(phase, duration)
	if phase == 0 then	com2_left_frequency_hz = com2_left_frequency_hz + 100		end
end

function com2_left_coarse_dwn_FNCT(phase, duration)
	if phase == 0 then	com2_left_frequency_hz = com2_left_frequency_hz - 100		end
end

-----------------------------------------
-- COM2 RIGHT -- FINE AND COARSE KNOBS --
-----------------------------------------
function com2_right_fine_up_FNCT(phase, duration)
	if phase == 0 then	com2_right_frequency_hz = com2_right_frequency_hz + 2.5		end
end

function com2_right_fine_dwn_FNCT(phase, duration)
	if phase == 0 then	com2_right_frequency_hz = com2_right_frequency_hz - 2.5		end
end

function com2_right_coarse_up_FNCT(phase, duration)
	if phase == 0 then	com2_right_frequency_hz = com2_right_frequency_hz + 100		end
end

function com2_right_coarse_dwn_FNCT(phase, duration)
	if phase == 0 then	com2_right_frequency_hz = com2_right_frequency_hz - 100		end
end

-----------------------------------------------
-- ADF1 LEFT -- ONE, TENS AND HUNDREDS KNOBS --
-----------------------------------------------
function adf1_left_one_up_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz + 1		end
end

function adf1_left_one_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz - 1		end
end

function adf1_left_tens_up_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz + 10		end
end

function adf1_left_tens_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz - 10		end
end

function adf1_left_hundreds_up_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz + 100		end
end

function adf1_left_hundreds_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_left_frequency_hz = adf1_left_frequency_hz - 100		end
end

------------------------------------------------
-- ADF1 RIGHT -- ONE, TENS AND HUNDREDS KNOBS --
------------------------------------------------
function adf1_right_one_up_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz + 1		end
end

function adf1_right_one_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz - 1		end
end

function adf1_right_tens_up_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz + 10		end
end

function adf1_right_tens_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz - 10		end
end

function adf1_right_hundreds_up_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz + 100		end
end

function adf1_right_hundreds_dwn_FNCT(phase, duration)
	if phase == 0 then	adf1_right_frequency_hz = adf1_right_frequency_hz - 100		end
end

-----------------------------------------------
-- ADF2 LEFT -- ONE, TENS AND HUNDREDS KNOBS --
-----------------------------------------------
function adf2_left_one_up_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz + 1		end
end

function adf2_left_one_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz - 1		end
end

function adf2_left_tens_up_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz + 10		end
end

function adf2_left_tens_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz - 10		end
end

function adf2_left_hundreds_up_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz + 100		end
end

function adf2_left_hundreds_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_left_frequency_hz = adf2_left_frequency_hz - 100		end
end

------------------------------------------------
-- ADF2 RIGHT -- ONE, TENS AND HUNDREDS KNOBS --
------------------------------------------------
function adf2_right_one_up_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz + 1		end
end

function adf2_right_one_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz - 1		end
end

function adf2_right_tens_up_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz + 10		end
end

function adf2_right_tens_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz - 10		end
end

function adf2_right_hundreds_up_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz + 100		end
end

function adf2_right_hundreds_dwn_FNCT(phase, duration)
	if phase == 0 then	adf2_right_frequency_hz = adf2_right_frequency_hz - 100		end
end





------------------------------- COMMANDS CREATION -------------------------------

create_command("laminar/md82cmd/radios/com1_left_fine_up","no description",com1_left_fine_up_FNCT)
create_command("laminar/md82cmd/radios/com1_left_fine_dwn","no description",com1_left_fine_dwn_FNCT)
create_command("laminar/md82cmd/radios/com1_left_coarse_up","no description",com1_left_coarse_up_FNCT)
create_command("laminar/md82cmd/radios/com1_left_coarse_dwn","no description",com1_left_coarse_dwn_FNCT)

create_command("laminar/md82cmd/radios/com1_right_fine_up","no description",com1_right_fine_up_FNCT)
create_command("laminar/md82cmd/radios/com1_right_fine_dwn","no description",com1_right_fine_dwn_FNCT)
create_command("laminar/md82cmd/radios/com1_right_coarse_up","no description",com1_right_coarse_up_FNCT)
create_command("laminar/md82cmd/radios/com1_right_coarse_dwn","no description",com1_right_coarse_dwn_FNCT)

create_command("laminar/md82cmd/radios/com2_left_fine_up","no description",com2_left_fine_up_FNCT)
create_command("laminar/md82cmd/radios/com2_left_fine_dwn","no description",com2_left_fine_dwn_FNCT)
create_command("laminar/md82cmd/radios/com2_left_coarse_up","no description",com2_left_coarse_up_FNCT)
create_command("laminar/md82cmd/radios/com2_left_coarse_dwn","no description",com2_left_coarse_dwn_FNCT)

create_command("laminar/md82cmd/radios/com2_right_fine_up","no description",com2_right_fine_up_FNCT)
create_command("laminar/md82cmd/radios/com2_right_fine_dwn","no description",com2_right_fine_dwn_FNCT)
create_command("laminar/md82cmd/radios/com2_right_coarse_up","no description",com2_right_coarse_up_FNCT)
create_command("laminar/md82cmd/radios/com2_right_coarse_dwn","no description",com2_right_coarse_dwn_FNCT)

create_command("laminar/md82cmd/radios/adf1_left_one_up","no description",adf1_left_one_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_left_one_dwn","no description",adf1_left_one_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf1_left_tens_up","no description",adf1_left_tens_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_left_tens_dwn","no description",adf1_left_tens_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf1_left_hundreds_up","no description",adf1_left_hundreds_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_left_hundreds_dwn","no description",adf1_left_hundreds_dwn_FNCT)

create_command("laminar/md82cmd/radios/adf1_right_one_up","no description",adf1_right_one_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_right_one_dwn","no description",adf1_right_one_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf1_right_tens_up","no description",adf1_right_tens_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_right_tens_dwn","no description",adf1_right_tens_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf1_right_hundreds_up","no description",adf1_right_hundreds_up_FNCT)
create_command("laminar/md82cmd/radios/adf1_right_hundreds_dwn","no description",adf1_right_hundreds_dwn_FNCT)

create_command("laminar/md82cmd/radios/adf2_left_one_up","no description",adf2_left_one_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_left_one_dwn","no description",adf2_left_one_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf2_left_tens_up","no description",adf2_left_tens_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_left_tens_dwn","no description",adf2_left_tens_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf2_left_hundreds_up","no description",adf2_left_hundreds_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_left_hundreds_dwn","no description",adf2_left_hundreds_dwn_FNCT)

create_command("laminar/md82cmd/radios/adf2_right_one_up","no description",adf2_right_one_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_right_one_dwn","no description",adf2_right_one_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf2_right_tens_up","no description",adf2_right_tens_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_right_tens_dwn","no description",adf2_right_tens_dwn_FNCT)
create_command("laminar/md82cmd/radios/adf2_right_hundreds_up","no description",adf2_right_hundreds_up_FNCT)
create_command("laminar/md82cmd/radios/adf2_right_hundreds_dwn","no description",adf2_right_hundreds_dwn_FNCT)







----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
--function flight_start()
	--none
--end




-- REGULAR RUNTIME
function after_physics()

	-- ADF FREQUENCIES LIMITS:
	if adf1_left_frequency_hz < 150 then adf1_left_frequency_hz = 150 end
	if adf1_left_frequency_hz > 1800 then adf1_left_frequency_hz = 1800 end


end


