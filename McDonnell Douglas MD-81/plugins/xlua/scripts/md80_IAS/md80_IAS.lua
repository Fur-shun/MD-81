
---------------------------------------------------------------
-- CREATING AND CONTROLLING THE IAS CUSTOM SPEED BUGS DATAREFS
---------------------------------------------------------------



------------------------------- FUNCTIONS FOR WRITABLE DATAREFS -------------------------------

function custom_bug1_func()
	-- RESTRICT THE BUG EXCURSION DEPENDING ON NEXT BUG POSITION, AVOIDING OVERLAP
	if (custom_bug1 > custom_bug2) then
		custom_bug1 = custom_bug2
	end
end


function custom_bug2_func()
	-- RESTRICT THE BUG EXCURSION DEPENDING ON NEXT BUG POSITION, AVOIDING OVERLAP
	if (custom_bug2 > custom_bug3) then
		custom_bug2 = custom_bug3
	end
end


function custom_bug3_func()
	-- RESTRICT THE BUG EXCURSION DEPENDING ON NEXT BUG POSITION, AVOIDING OVERLAP
	if (custom_bug3 > custom_bug4) then
		custom_bug3 = custom_bug4
	end
end


function custom_bug4_func()
	-- RESTRICT THE LAST BUG EXCURSION ON THE MAXIMUM OF 1.0, AVOIDING ENDLESS ROUNDS
	if (custom_bug4 > 1.0) then
		custom_bug4 = 1.0
	end
end





----------------------------------- LOCATE AND/OR CREATE DATAREFS -----------------------------------

custom_bug1 = create_dataref("laminar/md82/IAS/custom_bug1","number",custom_bug1_func) --> excursion round goes from 0.0 to 1.0
custom_bug2 = create_dataref("laminar/md82/IAS/custom_bug2","number",custom_bug2_func)
custom_bug3 = create_dataref("laminar/md82/IAS/custom_bug3","number",custom_bug3_func)
custom_bug4 = create_dataref("laminar/md82/IAS/custom_bug4","number",custom_bug4_func)






--------------------------------- RUNTIME ---------------------------------
function after_physics()
	--none
end


