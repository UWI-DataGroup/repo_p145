
#   META DATA
##  Program:        Carib_001.py
##  Project:        Macroscale Walkability
##  Sub-Project:    Walkability Index
##  Analyst:        Kern Rocke
##  Date Created:   07/08/2022
##  Date Modified:  09/08/2022
##  Algorithm Task: Creating Building Centroids

"""
This algorithm provides the first step in estimating
the neighbourhood walkscore for countries within the Caribbean
region.

This algorthim is written in python with an intention to 
be executed within QGIS. Note: Filepaths should be altered
for the specific machine being used. 

Using the Worldwide buiding dataset from Microsoft and 
OSM building layers, the centroids for each building will
be created for later processing in STATA (carib_002) to convert the 
geocoordinates to google plus codes which will be used to 
get the walkscore for each building centroid

"""

#   Load Packages
import os
import processing
from osgeo import ogr

# File path for JSON file for Anguilla
fn = "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145/version01/1-input/GIS Data/Country Buildings/Anguilla/Building/Anguilla.geojsonl"

# Load layer into QGIS interface
layer = iface.addVectorLayer(fn, '', 'ogr')

# Create centroids for each building
parameters_centroid = {
    'ALL_PARTS': False,
    'INPUT': '/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145/version01/1-input/GIS Data/Country Buildings/Anguilla/Building/Anguilla.geojsonl|layername=Anguilla',
    'OUTPUT': '/Users/kernrocke/Downloads/centroid_test.shp'
}
processing.run("native:centroids", parameters_centroid)

# Adding latitude and longitude to centroid layer
parameters_geometry = {
    'CALC_METHOD' : 0, 
    'INPUT' : '/Users/kernrocke/Downloads/centroid_test.shp', 
    'OUTPUT' : '/Users/kernrocke/Downloads/centroid_test1.shp' 
    }

processing.run("qgis:exportaddgeometrycolumns", parameters_geometry)

# Remove centroid data files without geocoordinates
if os.path.isfile('/Users/kernrocke/Downloads/centroid_test.shp'):
   os.remove('/Users/kernrocke/Downloads/centroid_test.shp')
if os.path.isfile('/Users/kernrocke/Downloads/centroid_test.dbf'):
   os.remove('/Users/kernrocke/Downloads/centroid_test.dbf')
if os.path.isfile('/Users/kernrocke/Downloads/centroid_test.shx'):
   os.remove('/Users/kernrocke/Downloads/centroid_test.shx')
if os.path.isfile('/Users/kernrocke/Downloads/centroid_test.prj'):
   os.remove('/Users/kernrocke/Downloads/centroid_test.prj')

# File path for building centroid layer
centroid = "/Users/kernrocke/Downloads/centroid_test1.shp"

# Load layer into QGIS interface
country_centroid = iface.addVectorLayer(centroid, '', 'ogr')


''''
# File path for country files
datapath = "/Users/kernrocke/Documents/Country"

country = ["Anguilla", 
            "Antigua_Barbuda",
            "Aruba",
            "Bahamas",
            "Barbados",
            "Belize",
            "Bonnaire",
            "BVI",
            "Cayman",
            "Curacao",
            "Cuba",
            "Dominica"
            "Dominican_Republic",
            "French_Martinique",
            "Grenada",
            "Guyana",
            "Haiti",
            "Jamaica",
            "Montserrat",
            "Puerto_Rico",
            "Saba",
            "Saint_Barthelemy",
            "Saint_Kitts_Nevis",
            "Saint_Vincent",
            "Sint_Eustatius",
            "Sint_Martin_1",
            "Sint_Martin_2",
            "Suriname",
            "Trinidad_Tobago",
            "Turks_Caicos",
            "USVI"
            ]
for x in country:
    x_country = datapath+"/"+x+".geojsonl"
    print(x_country)
    x_layer = iface.addVectorLayer(x_country, '', 'ogr')
    
"""

##################### END ##################################