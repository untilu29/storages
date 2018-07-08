ALTER TABLE gtfs_stop_times ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE gtfs_stop_times ADD COLUMN trip_index INT;
CREATE UNIQUE INDEX id_index ON gtfs_stop_times (id);
CREATE UNIQUE INDEX trip_index ON gtfs_stop_times (trip_index);

CREATE OR REPLACE FUNCTION trip_substitute(_version text, _limit INT)
 RETURNS text AS 
$func$
DECLARE
   _curs CURSOR;
   rec record;
   pre_seq INT DEFAULT 0;
   trip TEXT DEFAULT '';
   datas TEXT DEFAULT '';
   idx int default 0;

BEGIN
   OPEN _curs FOR EXECUTE 
   FORMAT('SELECT  id,stop_id, stop_sequence from tdi_smrt.gtfs_stop_times
											WHERE version = ' || quote_literal('%s') || ' 
											GROUP BY id, stop_id, stop_sequence
											ORDER BY  id, stop_sequence
											LIMIT %s',_version, _limit)  
    FOR UPDATE;

   LOOP
      FETCH NEXT FROM _curs INTO rec;
      EXIT WHEN rec IS NULL;

   --   RAISE NOTICE '%', rec.tbl_id;
		--		IF rec.stop_id LIKE 'EW%' THEN 
       RAISE NOTICE 'Update for %', _curs; 
         IF pre_seq > rec.stop_sequence THEN
  --				datas := datas || rec.stop_id || ':' || rec.stop_sequence || ',';
   --           datas := datas || idx::text || ',';
         idx:= idx+1;
         datas := datas || trip|| '--';
         trip:= '';
				END IF;
            trip := trip ||  rec.stop_id;
           pre_seq:= rec.stop_sequence;
        UPDATE tdi_smrt.gtfs_stop_times 
			  SET trip_index = idx 
			  WHERE id = rec.id and VERSION = _version;

   END LOOP;
	 RETURN datas;
END 
$func$  LANGUAGE plpgsql;


SELECT trip_substitute('smrt_sg_bus', 100);


SELECT * 
  FROM   tdi_smrt.gtfs_stop_times 
  WHERE  trip_index IS NOT NULL 

WITH trip_split_
  
SELECT    md5(min(arrival_time) || '/' 
                    || array_to_string(array_agg(stop_id),'-')) AS trip_id,
								   min(arrival_time) || '/' 
                    || array_to_string(array_agg(stop_id),'-') AS journey,
									trip_index                                                     AS index 
  FROM     tdi_smrt.gtfs_stop_times 
  WHERE    trip_index IS NOT NULL 
  AND          version = 'smrt_sg_bus' 
  GROUP BY trip_index 
  ORDER BY trip_index
