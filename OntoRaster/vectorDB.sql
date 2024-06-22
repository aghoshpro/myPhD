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












SELECT v10."v0" AS "v0", v10."v3m6" AS "v3m6"
FROM ((SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v2."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END, rasdaman_op.get_min_longitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_max_latitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lon_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lat_x(v2."raster_name", v2."field_name")),')) from ', v2."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END AS "v3m6"
FROM "region_sweden" v1, "raster_lookup_x1" v2
WHERE ((POSITION('Snow_Cover' IN v2."field_name") > 0) AND (POSITION('Winter' IN v2."raster_name") > 0) AND v2."raster_name" IS NOT NULL AND v2."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_GEOMETRYN(v1."geom",1) IS NOT NULL
    ELSE v1."geom" IS NOT NULL 
END AND 'Linköping' = v1."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v5."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END, rasdaman_op.get_min_longitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_max_latitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lon_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lat_x(v5."raster_name", v5."field_name")),')) from ', v5."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END AS "v3m6"
FROM "region_bavaria" v4, "raster_lookup_x1" v5
WHERE ((POSITION('Snow_Cover' IN v5."field_name") > 0) AND (POSITION('Winter' IN v5."raster_name") > 0) AND v5."raster_name" IS NOT NULL AND v5."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_GEOMETRYN(v4."geom",1) IS NOT NULL
    ELSE v4."geom" IS NOT NULL 
END AND 'Linköping' = v4."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v8."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END, rasdaman_op.get_min_longitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_max_latitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lon_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lat_x(v8."raster_name", v8."field_name")),')) from ', v8."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END AS "v3m6"
FROM "region_south_tyrol" v7, "raster_lookup_x1" v8
WHERE ((POSITION('Snow_Cover' IN v8."field_name") > 0) AND (POSITION('Winter' IN v8."raster_name") > 0) AND v8."raster_name" IS NOT NULL AND v8."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_GEOMETRYN(v7."geom",1) IS NOT NULL
    ELSE v7."geom" IS NOT NULL 
END AND 'Linköping' = v7."name_3")
)) v10


SELECT v10."v0" AS "v0", v10."v3m6" AS "v3m6"
FROM ((SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v2."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END, rasdaman_op.get_min_longitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_max_latitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lon_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lat_x(v2."raster_name", v2."field_name")),')) from ', v2."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END AS "v3m6"
FROM "region_sweden" v1, "raster_lookup_x1" v2
WHERE ((POSITION('Snow_Cover' IN v2."field_name") > 0) AND (POSITION('Sweden' IN v2."raster_name") > 0) AND v2."raster_name" IS NOT NULL AND v2."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_GEOMETRYN(v1."geom",1) IS NOT NULL
    ELSE v1."geom" IS NOT NULL 
END AND 'Linköping' = v1."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v5."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END, rasdaman_op.get_min_longitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_max_latitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lon_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lat_x(v5."raster_name", v5."field_name")),')) from ', v5."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END AS "v3m6"
FROM "region_bavaria" v4, "raster_lookup_x1" v5
WHERE ((POSITION('Snow_Cover' IN v5."field_name") > 0) AND (POSITION('Sweden' IN v5."raster_name") > 0) AND v5."raster_name" IS NOT NULL AND v5."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_GEOMETRYN(v4."geom",1) IS NOT NULL
    ELSE v4."geom" IS NOT NULL 
END AND 'Linköping' = v4."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v8."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END, rasdaman_op.get_min_longitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_max_latitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lon_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lat_x(v8."raster_name", v8."field_name")),')) from ', v8."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END AS "v3m6"
FROM "region_south_tyrol" v7, "raster_lookup_x1" v8
WHERE ((POSITION('Snow_Cover' IN v8."field_name") > 0) AND (POSITION('Sweden' IN v8."raster_name") > 0) AND v8."raster_name" IS NOT NULL AND v8."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_GEOMETRYN(v7."geom",1) IS NOT NULL
    ELSE v7."geom" IS NOT NULL 
END AND 'Linköping' = v7."name_3")
)) v10	


















SELECT v10."v0" AS "v0", v10."v3m6" AS "v3m6"
FROM ((SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v2."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END, rasdaman_op.get_min_longitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_max_latitude_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lon_x(v2."raster_name", v2."field_name"), rasdaman_op.get_res_lat_x(v2."raster_name", v2."field_name")),')) from ', v2."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v1."geom",1)) ELSE ST_ASTEXT(v1."geom") END AS "v3m6"
FROM "region_sweden" v1, "raster_lookup_x1" v2
WHERE ((POSITION('Snow' IN v2."field_name") > 0) AND (POSITION('Sweden' IN v2."raster_name") > 0) AND v2."raster_name" IS NOT NULL AND v2."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v1."geom") = 1) THEN ST_GEOMETRYN(v1."geom",1) IS NOT NULL
    ELSE v1."geom" IS NOT NULL 
END AND 'Linköping' = v1."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v5."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END, rasdaman_op.get_min_longitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_max_latitude_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lon_x(v5."raster_name", v5."field_name"), rasdaman_op.get_res_lat_x(v5."raster_name", v5."field_name")),')) from ', v5."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v4."geom",1)) ELSE ST_ASTEXT(v4."geom") END AS "v3m6"
FROM "region_bavaria" v4, "raster_lookup_x1" v5
WHERE ((POSITION('Snow' IN v5."field_name") > 0) AND (POSITION('Sweden' IN v5."raster_name") > 0) AND v5."raster_name" IS NOT NULL AND v5."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v4."geom") = 1) THEN ST_GEOMETRYN(v4."geom",1) IS NOT NULL
    ELSE v4."geom" IS NOT NULL 
END AND 'Linköping' = v4."name_2")
)UNION ALL 
(SELECT rasdaman_op.query2numeric(CONCAT('select avg_cells(clip(c[',rasdaman_op.timestamp2grid('2022-08-24T00:00:00+00:00', v8."raster_name"),', 0:* , 0:*],' , rasdaman_op.geo2grid_final(CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END, rasdaman_op.get_min_longitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_max_latitude_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lon_x(v8."raster_name", v8."field_name"), rasdaman_op.get_res_lat_x(v8."raster_name", v8."field_name")),')) from ', v8."raster_name", ' as c')) AS "v0", CASE WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_ASTEXT(ST_GEOMETRYN(v7."geom",1)) ELSE ST_ASTEXT(v7."geom") END AS "v3m6"
FROM "region_south_tyrol" v7, "raster_lookup_x1" v8
WHERE ((POSITION('Snow' IN v8."field_name") > 0) AND (POSITION('Sweden' IN v8."raster_name") > 0) AND v8."raster_name" IS NOT NULL AND v8."field_name" IS NOT NULL AND CASE     WHEN (ST_NUMGEOMETRIES(v7."geom") = 1) THEN ST_GEOMETRYN(v7."geom",1) IS NOT NULL
    ELSE v7."geom" IS NOT NULL 
END AND 'Linköping' = v7."name_3")
)) v10
