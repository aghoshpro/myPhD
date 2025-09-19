select * from raster_lookup_x

select * from raster_lookup_x1

select * from raster_lookup_view_x


CREATE TABLE raster_lookup_x1 AS SELECT * FROM raster_lookup_view_x;

ALTER TABLE raster_lookup_x1 ADD PRIMARY KEY (raster_id);

UPDATE raster_lookup_x1
SET raster_name = 'Winter_in_Sweden'
WHERE raster_name = 'Winter_in_sweden1'
RETURNING *;



DELETE FROM raster_lookup_x1
WHERE raster_id = '2078'
RETURNING *;

SELECT raster_id, field_name ILIKE CONCAT('%',field_name,'%') AS field FROM raster_lookup_x1

SELECT rasdaman_op.get_min_longitude_x('Sweden', 'Snow')


SELECT * FROM raster_lookup_x1 
WHERE raster_name ILIKE CONCAT('%','Winter_in_Sweden','%') AND field_name ILIKE CONCAT('%', 'snow', '%');

	
SELECT end_time_grid
FROM raster_lookup_x1 
WHERE raster_name = (SELECT raster_name FROM raster_lookup_x1 WHERE field_name ILIKE CONCAT('%','snow','%'));


SELECT raster_id, raster_name, field_name AS field FROM raster_lookup_x1 
WHERE raster_name = (SELECT raster_name FROM raster_lookup_x1 WHERE field_name ILIKE CONCAT('%','temp','%')) AND raster_name ILIKE CONCAT('%','Sweden','%')









