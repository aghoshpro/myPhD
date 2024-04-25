[QueryItem="check_rasdaman_conn"]
PREFIX : <http://www.semanticweb.org/arkaghosh/OntoRaster/>

select * {
?x :hasConnection ?conn .
}
[QueryItem="get_regions"]
PREFIX : <http://www.semanticweb.org/arkaghosh/OntoRaster/>

select * {
?x rdfs:label ?region_name .
}
[QueryItem="averageRASTER"]
PREFIX : <http://www.semanticweb.org/arkaghosh/OntoRaster/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rasdb: <http://www.semanticweb.org/RasterDataCube/>

select * {
?x :averageRASTER ?avg_temp .
}
[QueryItem="getRasterMeta"]
PREFIX : <http://www.semanticweb.org/arkaghosh/OntoRaster/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rasdb: <http://www.semanticweb.org/RasterDataCube/>

select * {
?r rasdb:hasRasterName ?raster_name 
}