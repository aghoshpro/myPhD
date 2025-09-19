-- Vector Data

SELECT * FROM region_sweden;

SELECT gid, gid_0, name_1, name_2, country FROM region_sweden;

SELECT gid, name_2, ST_NPoints(geom), geom FROM region_sweden ORDER BY ST_NPoints(geom) DESC ;

SELECT ST_NPoints('POINT(77.54889 13.00339)') ; -- 1 Point

--- GeoJSON
SELECT ST_AsGeoJSON('MULTIPOLYGON(((-108.72070312499997 34.99400375757577,-100.01953124999997 46.58906908309183,-90.79101562499996 34.92197103616377,-108.72070312499997 34.99400375757577),(-100.10742187499997 41.47566020027821,-102.91992187499996 37.61423141542416,-96.85546874999996 37.54457732085582,-100.10742187499997 41.47566020027821)),((-85.16601562499999 34.84987503195417,-80.771484375 28.497660832963476,-76.904296875 34.92197103616377,-85.16601562499999 34.84987503195417)))');

SELECT name_2, ST_AsGeoJSON(geom) FROM region_sweden;

-- GeoNames

SELECT * FROM geonames_se0;

SELECT * FROM geonames_se0 WHERE name ILIKE '%Umeå%';

SELECT * FROM geonames_se0 WHERE feature_code = 'ADM2';

SELECT * FROM geonames_it WHERE feature_code = 'ADM1';

SELECT DISTINCT feature_code FROM geonames_se0 ORDER BY feature_code ASC;


-- feature code : http://www.geonames.org/export/codes.html

SELECT *, ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) FROM geonames_se0 WHERE feature_code = 'RSTN';

SELECT *, ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) FROM geonames_it WHERE feature_code = 'RSTN';

SELECT *, ST_Point(longitude, latitude, 4326) FROM geonames_it WHERE feature_code = 'RSTN';

SELECT geonameid, name, ST_Point(longitude, latitude, 4326) geom, ST_AsText(ST_Point(longitude, latitude, 4326)) pointWKT FROM geonames_se0 WHERE feature_code = 'RSTN';

SELECT geonameid, name, ST_Point(longitude, latitude, 4326) geom, ST_AsText(ST_Point(longitude, latitude, 4326)) pointWKT FROM geonames_it WHERE feature_code = 'RSTN';

SELECT geonameid, name, ST_Point(longitude, latitude, 4326) geom, ST_AsText(ST_Point(longitude, latitude, 4326)) pointWKT FROM geonames_all WHERE feature_code = 'HSP' AND country_code = 'IN';

-- 3DCityDB

