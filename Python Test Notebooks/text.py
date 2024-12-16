# import os
# import sys

# def require_package(package_name):
#     try:
#         # Try to import the package
#         __import__(package_name)
#     except ImportError:
#         # If not found, install it
#         print(f"Package '{package_name}' not found. Installing...")
#         os.system(f"{sys.executable} -m pip install {package_name}")

# # Example usage
# require_package("opencv-python")

# # Now you can safely import and use the packages
# # import pandas as pd
# # import numpy as np
# # import seaborn as sns

# print("All packages are installed and ready to use!")

from shapely import Point, Polygon, bounds, wkt

geomm = 'POLYGON ((11.5028 48.1255, 11.5308 48.1255, 11.5308 48.1438, 11.5028 48.1438, 11.5028 48.1255))'
geomm = wkt.loads(geomm)
extent = bounds(geomm).tolist()
print(extent)



CREATE OR REPLACE FUNCTION rasdaman_op.query2geotiff02(IN query text,IN geomm text,IN filename text,IN fill_val double precision,OUT folium text)
    RETURNS text
    LANGUAGE 'plpython3u'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
    
AS $BODY$
from rasdapy.db_connector import DBConnector
from rasdapy.query_executor import QueryExecutor
from shapely import Point, Polygon, bounds, wkt
import numpy as np
import os
from osgeo import gdal, osr
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from rasterio.plot import show, reshape_as_image, reshape_as_raster, reshape_as_image
from folium.raster_layers import ImageOverlay

def query2folium(query, region, filename, fill_val):
    result = query_executor.execute_read(query) 
    numpy_array = result.to_array()
    if fill_val is not None:
        numpy_array = numpy_array.astype('float')
        numpy_array[numpy_array == fill_val] = 'nan'

    driver = gdal.GetDriverByName('GTiff')  
    nrows = numpy_array.shape[0]
    ncols = numpy_array.shape[1]
    nbands = len(numpy_array.shape)
    data_type = gdal.GDT_Float32
    grid_data = driver.Create('grid_data', ncols, nrows, 1, data_type)
    grid_data.GetRasterBand(1).WriteArray(numpy_array)
    srs = osr.SpatialReference()
    srs.ImportFromProj4('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
    grid_data.SetProjection(srs.ExportToWkt())
    region = wkt.loads(region)
    if region.geom_type == 'Polygon':    
        extent = bounds(region).tolist()
        grid_data.SetGeoTransform(getGeoTransform(extent, nrows, ncols))
        return 5	
    
    file_name = str(filename)+'.tif'
    driver.CreateCopy(file_name, grid_data, 0)  
    driver = None
    grid_data = None          
    os.remove('grid_data')
    elevRaster = rasterio.open(file_name)
    elevArray = elevRaster.read(1)
    boundList = [x for x in elevRaster.bounds]
    norm = Normalize(vmin=np.nanmin(elevArray), vmax=np.nanmax(elevArray))
    cmap = plt.cm.get_cmap('jet')
    def colormap_function(x):
        rgba = cmap(norm(x))
        return (rgba[0], rgba[1], rgba[2], rgba[3])

    rasLon = (boundList[3] + boundList[1])/2
    rasLat = (boundList[2] + boundList[0])/2
    mapCenter = [rasLon, rasLat]

    mf = folium.Map(location=mapCenter, zoom_start=13)
    folium.raster_layers.ImageOverlay(
        image=elevArray,
        bounds=[[boundList[1], boundList[0]], [boundList[3], boundList[2]]],
        opacity=0.52,
        colormap=colormap_function,  
		interactive=True,
        cross_origin=False,
    ).add_to(mf)
    
    return mf

db_connector = DBConnector("localhost", 7001, "rasadmin", "rasadmin")
query_executor = QueryExecutor(db_connector)
db_connector.open()

try:
   folium= query2folium(query, geomm, None, None)
   return str(folium)
finally:
   db_connector.close()	
$BODY$;
