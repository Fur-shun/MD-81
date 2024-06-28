
------------------------------------------------------
-- CONTROLLING THE THROTTLE / REVERSE CUSTOM DATAREFS
------------------------------------------------------



------------------------------- FUNCTIONS FOR WRITABLE DATAREFS -------------------------------

function throttle_left_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF NOT IN REVERSE
	if prop_mode_L == 1 then
		throttle_ratio_L = custom_throttle_left
	else
		custom_throttle_left = 0
	end
end

function throttle_right_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF NOT IN REVERSE
	if prop_mode_R == 1 then
		throttle_ratio_R = custom_throttle_right
	else
		custom_throttle_right = 0
	end
end

function throttle_all_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF NOT IN REVERSE
	if prop_mode_L+prop_mode_R == 2 then
		throttle_ratio_all = custom_throttle_all
	else
		custom_throttle_all = 0
	end
end



function reverse_left_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF IN REVERSE
	-- REVERSE ALLOWED ONLY FROM IDLE
	if custom_throttle_left < 0.1 then
		if custom_reverse_left > 0 then
			prop_mode_L = 3
			throttle_ratio_L = custom_reverse_left
		else
			prop_mode_L = 1
			throttle_ratio_L = 0
			custom_reverse_left = 0
		end
	else
		custom_reverse_left = 0
	end
end

function reverse_right_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF IN REVERSE
	-- REVERSE ALLOWED ONLY FROM IDLE
	if custom_throttle_right < 0.1 then
		if custom_reverse_right > 0 then
			prop_mode_R = 3
			throttle_ratio_R = custom_reverse_right
		else
			prop_mode_R = 1
			throttle_ratio_R = 0
			custom_reverse_right = 0
		end
	else
		custom_reverse_right = 0
	end
end

function reverse_all_func()
	-- LINK XPLANE DATAREF TO CUSTOM DATAREF IF IN REVERSE
	-- REVERSE ALLOWED ONLY FROM IDLE
	if custom_throttle_left + custom_throttle_right < 0.1 then
		if custom_reverse_all > 0 then
			prop_mode_L = 3
			prop_mode_R = 3
			throttle_ratio_all = custom_reverse_all
		else
			prop_mode_L = 1
			prop_mode_R = 1
			throttle_ratio_all = 0
			custom_reverse_all = 0
			custom_reverse_left = 0
			custom_reverse_right = 0
		end
	else
		custom_reverse_all = 0
	end
end





----------------------------------- LOCATE AND/OR CREATE DATAREFS -----------------------------------

prop_mode_L = find_dataref("sim/cockpit2/engine/actuators/prop_mode[0]") --> 0 feathered, 1 normal, 2 beta, 3 reverse
prop_mode_R = find_dataref("sim/cockpit2/engine/actuators/prop_mode[1]") --> 0 feathered, 1 normal, 2 beta, 3 reverse
throttle_ratio_L = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[0]")
throttle_ratio_R = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[1]")
throttle_ratio_all = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")


custom_throttle_left = create_dataref("laminar/md82/engine/throttle_left","number",throttle_left_func)
custom_throttle_right = create_dataref("laminar/md82/engine/throttle_right","number",throttle_right_func)
custom_throttle_all = create_dataref("laminar/md82/engine/throttle_all","number",throttle_all_func)

custom_reverse_left = create_dataref("laminar/md82/engine/reverse_left","number",reverse_left_func)
custom_reverse_right = create_dataref("laminar/md82/engine/reverse_right","number",reverse_right_func)
custom_reverse_all = create_dataref("laminar/md82/engine/reverse_all","number",reverse_all_func)






--------------------------------- RUNTIME ---------------------------------
function after_physics()

	-- LINK CUSTOM DATAREFS TO XPLANE DATAREFS IF NOT IN REVERSE
	if prop_mode_L+prop_mode_R == 2 then custom_throttle_all = throttle_ratio_all end
	if prop_mode_L == 1 then custom_throttle_left = throttle_ratio_L end
	if prop_mode_R == 1 then custom_throttle_right = throttle_ratio_R end

	-- LINK CUSTOM DATAREFS TO XPLANE DATAREFS IF IN REVERSE
	if prop_mode_L+prop_mode_R == 6 then custom_reverse_all = throttle_ratio_all end
	if prop_mode_L == 3 then custom_reverse_left = throttle_ratio_L end
	if prop_mode_R == 3 then custom_reverse_right = throttle_ratio_R end

end


