-- Convert MULTIPOLYGON to POLYGON if it contains only one polygon, else return as multipolygon in OGC WKT

SELECT gid, name_2 AS region_name, ST_NumGeometries(geom) AS numPoly,
       CASE
           WHEN ST_NumGeometries(geom) = 1 THEN ST_AsText(ST_GeometryN(geom, 1))
           ELSE ST_AsText(geom)
        END AS regionWkt
FROM region_sweden
ORDER BY 
  numPoly DESC;





-- 379 polygons within one multipolygon
SELECT gid, name_2, ST_NumGeometries(geom) AS numPoly, geom) FROM region_sweden WHERE name_2 = 'Norrtälje'

-- BBOX using ST_Envelop
SELECT gid, name_2, ST_NumGeometries(geom) AS numPoly, ST_AsText(ST_Envelope(geom)) FROM region_sweden WHERE name_2 = 'Norrtälje'

SELECT gid, name_2, ST_NumGeometries(geom) AS numPoly, ST_AsText(ST_Envelope(geom)) FROM region_sweden WHERE name_2 = 'Norrtälje'

SELECT ST_AsText(ST_Extent(geom)) AS bextent FROM region_sweden WHERE name_2 = 'Norrtälje'

-- To check and update SRID to 4326 to enable OSM
SELECT Find_SRID('public', 'region_sweden', 'geom');

SELECT UpdateGeometrySRID('region_sweden','geom',4326);



-- ///////////////////// EXPERIEMENTS ///////////////////
-- //////////////////////////////////////////////////////