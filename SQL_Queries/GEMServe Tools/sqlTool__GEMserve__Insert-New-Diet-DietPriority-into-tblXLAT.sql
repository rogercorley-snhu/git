--	INSERT NEW DIET & DIETPRIORITY into tblXLAT
---------------------------------------------------------------



--	01. Find the record you want to use as the template
--		Note the IDs of the Diet & DietPriority you want to copy
---------------------------------------------------------------

SELECT	*

FROM	tblXLAT

WHERE	KeyIn = '< KeyIn To Copy >'

--	example:	keyin = 'NPO 2300 Night Prior to Surg/Proc'


--	02. Insert Into tblXLAT the new and old values from template
---------------------------------------------------------------

INSERT INTO	tblXLAT

SELECT	xlatID, '< NEW DIET NAME >',KeyOut,Description

FROM	tblXLAT

WHERE
	ID IN (< ID FOR DIET >,< ID FOR DIETPRIORITY >)

--	example:	ID IN (1269,1312)
