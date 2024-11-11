import json
import shapely.wkt
from shapely import MultiPolygon

def wkt2geojson(wkt):
    """
    Converts a Well-Known Text (WKT) geometry to a GeoJSON feature.
    
    Parameters:
    wkt (str): The WKT representation of the geometry.
    
    Returns:
    dict: A GeoJSON feature object with the converted geometry.
    """
    # Parse the WKT string using Shapely
    geometry = shapely.wkt.loads(wkt)
    
    # Extract the coordinates based on the geometry type
    if geometry.geom_type == 'MultiPolygon':
        coordinates = [[list(map(list, poly.exterior.coords)) for poly in geometry.geoms]]
    elif geometry.geom_type == 'Polygon':
        coordinates = [list(map(list, geometry.exterior.coords))]
    else:
        raise ValueError(f"Unsupported geometry type: {geometry.geom_type}")
    
    return {
        "type": "Feature",
        "properties": {},
        "geometry": {
            "type": geometry.geom_type,
            "coordinates": coordinates
        }
    }

input_wkt = "MULTIPOLYGON(((-108.72070312499997 34.99400375757577,-100.01953124999997 46.58906908309183,-90.79101562499996 34.92197103616377,-108.72070312499997 34.99400375757577),(-100.10742187499997 41.47566020027821,-102.91992187499996 37.61423141542416,-96.85546874999996 37.54457732085582,-100.10742187499997 41.47566020027821)),((-85.16601562499999 34.84987503195417,-80.771484375 28.497660832963476,-76.904296875 34.92197103616377,-85.16601562499999 34.84987503195417)))"
# input_wkt = "POLYGON((0.6453443787141204 48.919824931252435,6.114094974760569 49.13327157060368,2.5170917532487294 44.03787769561788,0.6453443787141204 48.919824931252435))"

print(shapely.wkt.loads(input_wkt).geom_type)

geojson = wkt2geojson(input_wkt)

print(json.dumps(geojson))