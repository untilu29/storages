CREATE OR REPLACE FUNCTION f_curs1(_tbl text)
 RETURNS text AS 
$func$
DECLARE
   _curs refcursor;
   rec record;
   pre_seq INT DEFAULT 0;
   trip TEXT DEFAULT '';
   datas TEXT DEFAULT '';
   idx int default 0;

BEGIN
   OPEN _curs FOR EXECUTE 'SELECT  id,stop_id, stop_sequence from tdi_smrt.gtfs_stop_times
group by id, stop_id, stop_sequence
ORDER BY  id, stop_sequence
limit 495'  FOR UPDATE;

   LOOP
      FETCH NEXT FROM _curs INTO rec;
      EXIT WHEN rec IS NULL;

   --   RAISE NOTICE '%', rec.tbl_id;

 --     EXECUTE format('UPDATE %I SET tbl_id = tbl_id + 10 WHERE ctid = $1', _tbl)
			--	 EXECUTE ''
    --  USING rec.ctid;
		--		IF rec.stop_id LIKE 'EW%' THEN 
       RAISE NOTICE 'Update for %', _curs; 
         IF pre_seq > rec.stop_sequence THEN
  --				datas := datas || rec.stop_id || ':' || rec.stop_sequence || ',';
   --           datas := datas || idx::text || ',';
         idx:= idx+1;
         datas := datas || trip|| '----';
         trip:= '';
				END IF;
            trip := trip ||  rec.stop_id;
           pre_seq:= rec.stop_sequence;
       UPDATE tdi_smrt.gtfs_stop_times SET trip_index = idx WHERE id = rec.id;

   END LOOP;
	 RETURN datas;
END 
$func$  LANGUAGE plpgsql;


SELECT f_curs1('123');


select * from tdi_smrt.gtfs_stop_times WHERE trip_index is not null limit 500


select  min(arrival_time), array_agg(stop_id), trip_index from tdi_smrt.gtfs_stop_times
WHERE trip_index is not null 
GROUP BY trip_index
ORDER BY trip_index


