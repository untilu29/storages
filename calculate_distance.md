https://api.mapbox.com/directions/v5/mapbox/driving/126.989063,37.631690;127.606375,36.804423?access_token=pk.eyJ1Ijoibmd1eWVuYmFsaW5oIiwiYSI6ImNqZjB1MWR1MjA2bmUycWxuYzdtanp4dXIifQ.LpQ9cVotmi_Pk_CitmF-lQ


SELECT ST_SRID(borders.geom ) from borders where code = 'SE'
;


select ST_Length(ST_Intersection(
 borders.geom 
,ST_LineFromEncodedPolyline('i|sdFarbfWdzCemD_rBkgKbz@ifE}R{vCl|MmqGds@}kEngMioF|_CweFbcR_sE`nPkqQhnG}cCrxSwMpmE_eDlzFq_AdvI|dB~wRus@rwDitBr{CdMhmAi~AvlE`Qsj@ycG{hCmjGxY{_C}}Akf@aCraA')
)::geography)
from borders where code = 'SE'

select 
ST_Length(ST_LineFromEncodedPolyline('i|sdFarbfWdzCemD_rBkgKbz@ifE}R{vCl|MmqGds@}kEngMioF|_CweFbcR_sE`nPkqQhnG}cCrxSwMpmE_eDlzFq_AdvI|dB~wRus@rwDitBr{CdMhmAi~AvlE`Qsj@ycG{hCmjGxY{_C}}Akf@aCraA'
)::geography
)

SELECT 
sum(ST_Length_Spheroid(ST_LineFromEncodedPolyline('i|sdFarbfWdzCemD_rBkgKbz@ifE}R{vCl|MmqGds@}kEngMioF|_CweFbcR_sE`nPkqQhnG}cCrxSwMpmE_eDlzFq_AdvI|dB~wRus@rwDitBr{CdMhmAi~AvlE`Qsj@ycG{hCmjGxY{_C}}Akf@aCraA'),'SPHEROID["WGS 84",6378137,298.257223563]')
)
