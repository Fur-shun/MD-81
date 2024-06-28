
---------------------------------------------------------------
-- CREATING AND CONTROLLING THE CUSTOM WHEELS DATAREFS OF THE
-- MECHANICAL "TAKE OFF COMPUTER" ON THE PEDESTAL
-- THE COMPUTER WILL OUTPUT THE TRIM SETTING FROM 0 TO 12
--
---------------------------------------------------------------
-- TAKE-OFF STABILIZER TRIM SETTINGS TABLE (FROM REAL MD80):
---------------------------------------------------------------
--			FLAP SETTINGS
-- CG		  0°	 11°	 17°	 24°
-- %MAC ---------------------------------
-- 0		8.0		9.5		11		12
-- 5		7.0		8.0		9.0		10
-- 10		6.0		7.0		8.0		8.5
-- 15		5.0		5.5		6.5		7.0
-- 20		4.0		4.5		5.0		5.5
-- 25		3.0		3.0		3.5		3.5
-- 30		2.0		1.9		2.0		2.0
-- 35		0.5		0.5		0.5		0.0
--
---------------------------------------------------------------
-- CG LOCATION SCALES:
---------------------------------------------------------------
--                0-------15------35				%MAC (MD80)
--                |       |       |
--              -2.15     0      2.62				ft
--                |       |       |
--   -65.5       -26      0      31.4     71.2		inches (XP W&B window)
--      |---------|-------|-------|---------|
--   -1.7       -0.6      0      0.8        1.8		cgz dataref
---------------------------------------------------------------





------------------------------- FUNCTIONS -------------------------------

function empty_func()
	-- empty function placeholder for writable dataref
end

function compute_longtrim_func()
	-- COMPUTE THE LONG TRIM VALUE (AND THE GREEN POINTER POSITION ON THE PEDESTAL)
	-- ACCORDINGLY WITH THE SETTINGS TABLE ABOVE (APPROXIMATION FORMULA)
	-------------------\--------THE CG PART------/---\----THE FLAP PART----/
	output_long_trim = (8 - (8 * (input_cg / 38))) + (4 * (input_flap / 38))
end

function compute_cg_func()
	-- convert xplane cg deviation from default (about -1.7 +1.8 max, but the allowed range is -0.6 +0.8)
	-- to the md80 cg (from 0 to 35% MAC)
	-- assuming the default 0 xp = 15% MAC
	cg = 15 + (25 * cgz_ref_to_default)
	if cg < 0 then input_cg = 0 elseif cg > 35 then input_cg = 35 else input_cg = cg end
	cgz_ref_to_default_previous = cgz_ref_to_default
	compute_longtrim_func()
end





----------------------------------- LOCATE AND/OR CREATE DATAREFS -----------------------------------

--CG_indicator = find_dataref("sim/cockpit2/gauges/indicators/CG_indicator") --> XPlane gauge CG (from about 1.7 to -1.2 for the MD80)
cgz_ref_to_default = find_dataref("sim/flightmodel/misc/cgz_ref_to_default") --> XPlane CG deviation from the default (from about -1.7 to +1.8 for the MD80)

input_cg = create_dataref("laminar/md82/TOcomputer/input_cg","number",compute_longtrim_func) --> the CG value moved by manipulator (0-35 %MAC)
input_flap = create_dataref("laminar/md82/TOcomputer/input_flap","number",compute_longtrim_func) --> the FLAP value moved by manipulator (0-24)
output_long_trim = create_dataref("laminar/md82/TOcomputer/output_long_trim","number") --> the resulting computed long trim (0-12)





--------------------------------- RUNTIME ---------------------------------
function flight_start()
	cgz_ref_to_default_previous = 0
	compute_cg_func()
end


function after_physics()

	-- recompute the md80 cg if xplane cg is changed
	if cgz_ref_to_default ~= cgz_ref_to_default_previous then compute_cg_func() end
	
end


