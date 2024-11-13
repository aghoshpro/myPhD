# pip install -q lxml

from lxml import etree
from shapely.geometry import shape

tree = etree.parse('./CityGML/690_5334.gml')
root = tree.getroot()

buildings = root.xpath('//bldg:Building', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'})

for building in buildings:
    building_id = building.get('gml:id')
    footprint = shape(building.find('bldg:lod1Solid', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'}).find('gml:Solid').find('gml:exterior').find('gml:LinearRing').find('gml:posList'))
    print(f'Building ID: {building_id}, Footprint: {footprint}')



# bbox = (10.0, 50.0, 11.0, 51.0)  # (min_x, min_y, max_x, max_y)
# filtered_buildings = [b for b in buildings if shape(b.find('bldg:lod1Solid', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'}).find('gml:Solid').find('gml:exterior').find('gml:LinearRing').find('gml:posList')).bounds[0] >= bbox[0] and
#                                               shape(b.find('bldg:lod1Solid', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'}).find('gml:Solid').find('gml:exterior').find('gml:LinearRing').find('gml:posList')).bounds[1] >= bbox[1] and
#                                               shape(b.find('bldg:lod1Solid', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'}).find('gml:Solid').find('gml:exterior').find('gml:LinearRing').find('gml:posList')).bounds[2] <= bbox[2] and
#                                               shape(b.find('bldg:lod1Solid', namespaces={'bldg': 'http://www.opengis.net/citygml/building/2.0'}).find('gml:Solid').find('gml:exterior').find('gml:LinearRing').find('gml:posList')).bounds[3] <= bbox[3]]


# print(filtered_buildings)

