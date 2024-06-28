-- *******************************************************************
-- Helper datarefs for use on the sound system
-- Daniela Rodríguez Careri <dcareri@gmail.com>
-- Laminar Research
-- *******************************************************************

dr_battery = find_dataref("sim/cockpit2/electrical/battery_on[0]")
dr_speed_mach = find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
dr_speed_kias = find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
dr_on_ground = find_dataref("sim/flightmodel/failures/onground_any")
dr_throttle = find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
dr_flaps = find_dataref("sim/flightmodel2/controls/flap1_deploy_ratio")
dr_slats = find_dataref("sim/flightmodel2/controls/slat1_deploy_ratio")
dr_speedbrake = find_dataref("sim/flightmodel2/controls/speedbrake_ratio")
dr_stab_trim_pos = find_dataref("sim/flightmodel2/controls/stabilizer_deflection_degrees")
dr_parking_brake = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
dr_reverser = find_dataref("sim/cockpit2/annunciators/reverser_deployed")
dr_pack_L_rat = find_dataref("laminar/md82/bleedair/HVAC_L_press")
dr_pack_R_rat = find_dataref("laminar/md82/bleedair/HVAC_R_press")
dr_autopilot_on = find_dataref("sim/cockpit2/autopilot/servos_on")
dr_trim_pos = find_dataref("sim/flightmodel2/controls/elevator_trim")
dr_running_time = find_dataref("sim/time/total_running_time_sec")
output_long_trim = find_dataref("laminar/md82/TOcomputer/output_long_trim") --> from the custom TOcomputer script

dr_overspeed_warn = create_dataref("laminar/md82/sound/overspeed_warn", "number")
dr_config_warn_any = create_dataref("laminar/md82/sound/config_warn_any", "number")
dr_config_warn_flaps = create_dataref("laminar/md82/sound/config_warn_flaps", "number")
dr_config_warn_slats = create_dataref("laminar/md82/sound/config_warn_slats", "number")
dr_config_warn_stabilizer = create_dataref("laminar/md82/sound/config_warn_stabilizer", "number")
dr_config_warn_brakes = create_dataref("laminar/md82/sound/config_warn_brakes", "number")
dr_config_warn_spoilers = create_dataref("laminar/md82/sound/config_warn_spoilers", "number")
dr_packs_flow = create_dataref("laminar/md82/sound/packs_flow", "array[2]")
dr_trim_horn = create_dataref("laminar/md82/sound/trim_horn", "number")
dr_trim_warn = create_dataref("laminar/md82/sound/trim_warn", "number")
dr_trim_sound = create_dataref("laminar/md82/sound/trim_sound", "number")
dr_trim_speed = create_dataref("laminar/md82/sound/trim_speed", "number")
dr_trim_accum = create_dataref("laminar/md82/sound/trim_accum", "number")

local last_stab_pos = 0
local trim_deg_history = {}

function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function trim_horn_timer()
    local delta = math.abs( dr_stab_trim_pos - last_stab_pos )
    dr_trim_speed = delta * 100

    if dr_trim_speed == 0 then
       dr_trim_accum = 0
    else
       dr_trim_accum = dr_trim_accum + delta
    end

    -- Trigger horn if after having moved more than 1 degree, we're moving an additional 0.5 degrees
    if (dr_trim_accum > 1) and (dr_trim_accum % 0.5 >= 0) and
            (dr_trim_accum % 0.5 <= 0.1) and (dr_autopilot_on == 0) and (dr_battery == 1) then
        dr_trim_horn = 1
    else
        dr_trim_horn = 0
    end

    last_stab_pos = dr_stab_trim_pos

    -- Set dataref to signal if the horn or warn is playing so they don't overlap
    if (dr_trim_horn == 1 or dr_trim_warn == 1) then
        dr_trim_sound = 1
    else
        dr_trim_sound = 0
    end
end

function trim_warn_timer()
    if (dr_autopilot_on == 1) then
        -- print(table.concat(trim_deg_history,", "))
        table.insert(trim_deg_history, dr_stab_trim_pos)

        if table_length(trim_deg_history) >= 30 then
            local trim_pos_30s_ago = table.remove(trim_deg_history, 1)
            local delta = math.abs(dr_stab_trim_pos - trim_pos_30s_ago)
            print(delta)
            -- trigger warn if the autopilot is trimming and has moved more than 2 deg in the last 30 sec
            if (dr_autopilot_on == 1) and (delta > 2) and (dr_trim_speed > 0.2) and (dr_battery == 1) then
                dr_trim_warn = 1
            else
                dr_trim_warn = 0
            end
        end
    else
        dr_trim_warn = 0
        trim_deg_history = {}
    end
end


-- Maintain a dataref which will fire the trim horn
function md80_set_trim_horn()
    if is_timer_scheduled(trim_horn_timer) == false then
        run_at_interval(trim_horn_timer, 0.05)
    end
end

-- Maintain a dataref which will fire the trim aural warning
function md80_set_trim_warn()
    if is_timer_scheduled(trim_warn_timer) == false then
        run_at_interval(trim_warn_timer, 1)
    end
end

-- Trigger an overspeed warn when over Vmo/Vne
function md80_set_overspeed()

    if (dr_battery == 1 and (dr_speed_mach > 0.84 or dr_speed_kias > 340)) then
        dr_overspeed_warn = 1
    else
        dr_overspeed_warn = 0
    end

end

-- Trigger the config warning system
function md80_set_config_warn()

    if (dr_on_ground == 1 and dr_throttle > 0.65 and dr_reverser == 0 and dr_battery == 1) then

        if dr_flaps < 0.275 then
            dr_config_warn_flaps = 1
        else
            dr_config_warn_flaps = 0
        end

        if dr_slats < 0.5 then
            dr_config_warn_slats = 1
        else
            dr_config_warn_slats = 0
        end

		-- EVALUATE IF WHITE STABILIZER POINTER IS IN RANGE OF GREEN POINTER (1° tolerance)
        -- OLD LINE WITH FIXED VALUES: if dr_stab_trim_pos < -11 or dr_stab_trim_pos > -7 then
        if math.abs(math.abs(dr_stab_trim_pos) - output_long_trim) > 1 then
            dr_config_warn_stabilizer = 1
        else
            dr_config_warn_stabilizer = 0
        end

        if dr_parking_brake > 0.01 then
            dr_config_warn_brakes = 1
        else
            dr_config_warn_brakes = 0
        end

        if dr_speedbrake > 0.01 then
            dr_config_warn_spoilers = 1
        else
            dr_config_warn_spoilers = 0
        end

        if (dr_config_warn_flaps == 1 or dr_config_warn_slats == 1 or
            dr_config_warn_stabilizer == 1 or dr_config_warn_brakes == 1 or
            dr_config_warn_spoilers == 1) then
            dr_config_warn_any = 1
        else
            dr_config_warn_any = 0
        end

    else
        dr_config_warn_any = 0
        dr_config_warn_flaps = 0
        dr_config_warn_slats = 0
        dr_config_warn_stabilizer = 0
        dr_config_warn_brakes = 0
        dr_config_warn_spoilers = 0
    end

end

-- Map L/R datarefs to array to allow for FMOD event reuse
function md80_set_packs()
    dr_packs_flow[0] = dr_pack_L_rat
    dr_packs_flow[1] = dr_pack_R_rat
end


-- *******************************************************************
-- Hooks
-- *******************************************************************

function update_datarefs()
    md80_set_overspeed()
    md80_set_config_warn()
    md80_set_trim_horn()
    md80_set_trim_warn()
    md80_set_packs()
end

function after_physics()
    update_datarefs()
end

function after_replay()
    update_datarefs()
end
