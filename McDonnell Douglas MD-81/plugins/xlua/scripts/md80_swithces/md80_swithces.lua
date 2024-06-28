
--
-- THIS SCRIPT DEALS WITH VARIOUS CUSTOM SWITCHES
--


----------------------------------- LOCATE AND CREATE DATAREFS -----------------------------------
landing_lights_switch_nose = find_dataref("sim/cockpit2/switches/taxi_light_on")
landing_lights_switch_L = find_dataref("sim/cockpit2/switches/landing_lights_switch[1]")
landing_lights_switch_R = find_dataref("sim/cockpit2/switches/landing_lights_switch[2]")

nav_pos_lights = find_dataref("sim/cockpit2/switches/navigation_lights_on")
strobe_lights = find_dataref("sim/cockpit2/switches/strobe_lights_on")
--strobe_brightness_ratio = find_dataref("sim/flightmodel2/lights/strobe_brightness_ratio[0]")
--strobe_flash_now = find_dataref("sim/flightmodel2/lights/strobe_flash_now")
nose_on_ground = find_dataref("sim/flightmodel2/gear/on_ground[0]") -- NOSE GEAR ON GROUND Y/N
navstrobe_lights_switch = create_dataref("laminar/md82/switches/navstrobe_lights_switch","number") --> the pos-strobe switch in the panel (0=off 1=pos 2=both)

no_smoking = find_dataref("sim/cockpit2/switches/no_smoking") --> 0=off 1=auto 2=on
fasten_seat_belts = find_dataref("sim/cockpit2/switches/fasten_seat_belts") --> 0=off 1=auto 2=on

ckpt_door_slider_on = find_dataref("sim/cockpit2/switches/custom_slider_on[10]") --> ckpt door open=1 or close=0
ckpt_door_lock_switch = create_dataref("laminar/md82/switches/ckpt_door_locked","number") --> ckpt door lock switch open=0 locked=1





------------------------------- FUNCTIONS / COMMANDS CALLBACK -------------------------------

--------------------------------
-- NOSE LANDING LIGHTS SWITCH --
--------------------------------
function landing_lights_switch_nose_up(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_nose > 0) then
			landing_lights_switch_nose = landing_lights_switch_nose - 1
		end
	end
end

function landing_lights_switch_nose_dwn(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_nose < 2) then
			landing_lights_switch_nose = landing_lights_switch_nose + 1
		end
	end
end

--------------------------------
-- LEFT LANDING LIGHTS SWITCH --
--------------------------------
function landing_lights_switch_L_up(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_L > -1) then
			landing_lights_switch_L = landing_lights_switch_L - 1
		end
	end
end

function landing_lights_switch_L_dwn(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_L < 1) then
			landing_lights_switch_L = landing_lights_switch_L + 1
		end
	end
end

---------------------------------
-- RIGHT LANDING LIGHTS SWITCH --
---------------------------------
function landing_lights_switch_R_up(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_R > -1) then
			landing_lights_switch_R = landing_lights_switch_R - 1
		end
	end
end

function landing_lights_switch_R_dwn(phase, duration)
	if phase == 0 then
		if (landing_lights_switch_R < 1) then
			landing_lights_switch_R = landing_lights_switch_R + 1
		end
	end
end

--------------------------------------
-- NAV/POS AND STROBE LIGHTS SWITCH --
--------------------------------------
function navstrobe_lights_switch_up(phase, duration)
	if phase == 0 and navstrobe_lights_switch > 0 then
		navstrobe_lights_switch = navstrobe_lights_switch - 1
	end
end

function navstrobe_lights_switch_dwn(phase, duration)
	if phase == 0 and navstrobe_lights_switch < 2 then
		navstrobe_lights_switch = navstrobe_lights_switch + 1
	end
end

----------------------------------------
-- NO SMOKING AND SEAT BELTS SWITCHES --
----------------------------------------
function nosmoke_switch_up(phase, duration)
	if phase == 0 and no_smoking > 0 then
		no_smoking = no_smoking - 1
	end
end

function nosmoke_switch_dwn(phase, duration)
	if phase == 0 and no_smoking < 2 then
		no_smoking = no_smoking + 1
	end
end

function seatbelts_switch_up(phase, duration)
	if phase == 0 and fasten_seat_belts > 0 then
		fasten_seat_belts = fasten_seat_belts - 1
	end
end

function seatbelts_switch_dwn(phase, duration)
	if phase == 0 and fasten_seat_belts < 2 then
		fasten_seat_belts = fasten_seat_belts + 1
	end
end

------------------------------
-- COCKPIT DOOR LOCK SWITCH --
------------------------------
function ckpt_door_lock_toggle_funct(phase, duration)
	if phase == 0 then
		ckpt_door_lock_switch = math.abs(ckpt_door_lock_switch - 1) -- toggle from 0 and 1
	end
end




------------------------------- COMMANDS CREATION -------------------------------

create_command("laminar/md82cmd/switches/landing_lights_switch_nose_up","no description",landing_lights_switch_nose_up)
create_command("laminar/md82cmd/switches/landing_lights_switch_nose_dwn","no description",landing_lights_switch_nose_dwn)
create_command("laminar/md82cmd/switches/landing_lights_switch_L_up","no description",landing_lights_switch_L_up)
create_command("laminar/md82cmd/switches/landing_lights_switch_L_dwn","no description",landing_lights_switch_L_dwn)
create_command("laminar/md82cmd/switches/landing_lights_switch_R_up","no description",landing_lights_switch_R_up)
create_command("laminar/md82cmd/switches/landing_lights_switch_R_dwn","no description",landing_lights_switch_R_dwn)

create_command("laminar/md82cmd/switches/navstrobe_lights_switch_up","no description",navstrobe_lights_switch_up)
create_command("laminar/md82cmd/switches/navstrobe_lights_switch_dwn","no description",navstrobe_lights_switch_dwn)

create_command("laminar/md82cmd/switches/nosmoke_switch_up","no description",nosmoke_switch_up)
create_command("laminar/md82cmd/switches/nosmoke_switch_dwn","no description",nosmoke_switch_dwn)

create_command("laminar/md82cmd/switches/seatbelts_switch_up","no description",seatbelts_switch_up)
create_command("laminar/md82cmd/switches/seatbelts_switch_dwn","no description",seatbelts_switch_dwn)

create_command("laminar/md82cmd/switches/ckpt_door_lock_toggle","cockpit door lock toggle",ckpt_door_lock_toggle_funct)





----------------------------------- INIT VARIABLES -----------------------------------

keep_ckpt_door_close = 0




----------------------------------- RUNTIME CODE -----------------------------------


-- DO THIS EACH FLIGHT START
--function flight_start()
	--none
--end




-- REGULAR RUNTIME
function after_physics()

	-- keep door closed:
	if ckpt_door_slider_on == 1 and keep_ckpt_door_close == 1 then ckpt_door_slider_on = 0 end
	-- evaluate cockpit door and lock switch situations:
	if ckpt_door_slider_on == 0 and ckpt_door_lock_switch == 0 then keep_ckpt_door_close = 0 end
	if ckpt_door_slider_on == 1 and ckpt_door_lock_switch == 0 then keep_ckpt_door_close = 0 end
	if ckpt_door_slider_on == 1 and ckpt_door_lock_switch == 1 then keep_ckpt_door_close = 0 end
	if ckpt_door_slider_on == 0 and ckpt_door_lock_switch == 1 then keep_ckpt_door_close = 1 end

	-- evaluate when lit the positions and strobes (the real md80 does not light strobes until airborne):
	if navstrobe_lights_switch > 0 then
		nav_pos_lights = 1
		if navstrobe_lights_switch == 2 and nose_on_ground == 0 then strobe_lights = 1 else strobe_lights = 0 end
	else
		nav_pos_lights = 0
		strobe_lights = 0
	end

end


