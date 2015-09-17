INSERT NEW DIET & DIETPRIORITY into tblXLAT


use GEMserve4;
GO


select *
from tblXLAT
where keyin
--keyin = 'NPO 2300 Night Prior to Surg/Proc'

--INSERT INTO tblXLAT
select xlatid, '< NEW DIET NAME >',keyout,description

from tblXLAT
where id IN (1269,1312)
--keyin = 'NPO 2300 Night Prior to Surg/Proc'