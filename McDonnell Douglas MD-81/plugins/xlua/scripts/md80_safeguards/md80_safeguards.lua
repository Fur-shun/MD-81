-- THE FOLLOWING SCRIPT CREATE THE "laminar/md82/safeguard[N]" DATAREF
-- AND MANY "laminar/md82cmd/safeguardNN" COMMANDS, USED BY THE COCKPIT.OBJ
-- TO TOGGLE OPEN/CLOSE THE VARIOUS SAFEGUARD COVERS.
--
-- SAFEGUARD ASSIGNEMENTS ARE:
-- 0 starter L
-- 1 starter R
-- 2 ground proximity warn
-- 3 battery secure
-- 4
-- 5
-- 6
-- 7
-- 8
-- 9




-- total number of custom safeguard covers (10 means from 0 to 9)
NUM_BTN_COVERS = 10





----------------------------------- LOCAL VARIABLES -----------------------------------

local MD82_button_switch_cover_position_target = {}
for i = 0, NUM_BTN_COVERS-1 do MD82_button_switch_cover_position_target[i] = 0 end

local MD82_close_button_cover = {}
local MD82_button_switch_cover_CMDhandler = {}







----------------------------------- CREATE CUSTOM DATAREFS -----------------------------------

MD82_DR_button_switch_cover_position = create_dataref("laminar/md82/safeguard","array[" .. tostring(NUM_BTN_COVERS) .. "]")








----------------------------------- COMMAND HANDLERS FUNCTIONS -----------------------------------

for i = 0, NUM_BTN_COVERS-1 do

    -- CREATE THE CLOSE COVER FUNCTIONS
    MD82_close_button_cover[i] = function()
        MD82_button_switch_cover_position_target[i] = 0.0
    end


    -- CREATE THE COVER HANDLER FUNCTIONS
    MD82_button_switch_cover_CMDhandler[i] = function(phase, duration)

        if phase == 0 then
            if MD82_button_switch_cover_position_target[i] == 0.0 then
                MD82_button_switch_cover_position_target[i] = 1.0
                if is_timer_scheduled(MD82_close_button_cover[i]) then
                    stop_timer(MD82_close_button_cover[i])
                end
                --NO MORE AUTOCLOSE--> run_after_time(MD82_close_button_cover[i], 30.0) -- close all safeguard automatically after 30 sec
            elseif MD82_button_switch_cover_position_target[i] == 1.0 then
                MD82_button_switch_cover_position_target[i] = 0.0
                if is_timer_scheduled(MD82_close_button_cover[i]) then
                    stop_timer(MD82_close_button_cover[i])
                end
            end
        end
    end

end






----------------------------------- CREATE CUSTOM COMMANDS -----------------------------------

MD82_CMD_button_switch_cover = {}
for i = 0, NUM_BTN_COVERS-1 do
    MD82_CMD_button_switch_cover[i] = create_command("laminar/md82cmd/safeguard" .. string.format("%02d", i), "Safeguard Cover" .. string.format("%02d", i), MD82_button_switch_cover_CMDhandler[i])
end







----------------------------------- ANIMATION UTILITY -----------------------------------

function MD82_set_animation_position(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end


function MD82_button_switch_cover_animation()

    for i = 0, NUM_BTN_COVERS-1 do
        MD82_DR_button_switch_cover_position[i] = MD82_set_animation_position(MD82_DR_button_switch_cover_position[i], MD82_button_switch_cover_position_target[i], 0.0, 1.0, 20.0)
    end

end









----------------------------------- RUNTIME -----------------------------------

-- DO THIS EACH FLIGHT START
function flight_start()
	MD82_button_switch_cover_position_target[3] = 0
end


function before_physics() 
	
	MD82_button_switch_cover_animation()	

end


