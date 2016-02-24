PARAMETERS FILELOC,DAY;
select distinct trans_dtl.uws_seq,TRIM(ref),(select obj_num from micros.rvc_def where rvc_seq = micros.chk_dtl.rvc_seq),chk_num,dateformat(chk_clsd_date_time,'mm-dd-yy'),dateformat(chk_clsd_date_time,'hh:mm:ss'),pymnt_ttl
from micros.chk_dtl,micros.trans_dtl,micros.ref_dtl,micros.uws_def,micros.tmed_dtl
where micros.chk_dtl.chk_seq=micros.trans_dtl.chk_seq
and micros.ref_dtl.trans_seq=micros.trans_dtl.trans_seq
and micros.uws_def.uws_seq=micros.trans_dtl.uws_seq
and micros.tmed_dtl.trans_seq=micros.trans_dtl.trans_seq
and micros.tmed_dtl.tmed_seq=(select tmed_seq from micros.tmed_def where name='Offline' )
and micros.tmed_dtl.dtl_seq=micros.ref_dtl.parent_dtl_seq
and dateformat(chk_clsd_date_time,'yyyy-mm-dd') =dateformat( now(*){DAY},'yyyy-mm-dd');
output to {FILELOC}
format ascii quote ''  ;