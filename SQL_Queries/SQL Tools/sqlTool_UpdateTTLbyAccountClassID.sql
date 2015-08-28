update t1
set t1.dailylimit = '4.50'
from tblaccountttl as t1
join tblaccountohd as a on t1.accountno = a.accountno
where a.accountclassid = 30