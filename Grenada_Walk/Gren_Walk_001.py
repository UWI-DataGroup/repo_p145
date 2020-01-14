
##  META-DATA COMMENTS
##  Program:		Gren_Walk_001
##  Project:      	Macroscale Walkability- PhD
##	Sub-Project:	Walkability Computation - Grenada 
##  Analyst:		Kern Rocke
##	Date Created:	12/01/2019
##	Date Modified: 	14/01/2019
##  Algorithm Task: Importing Grenada Shapefiles


###########

# Analysis comments

#   This algorithm seeks to import Grenada shapefile into either ArcGIS/QGIS. The layers of interest are:
#   buildings (land use), road network, enumeration districts and population/residential densityu

# Note the below syntax pertains to applications to ArcGIS python counsel

Import system modules
import arcpy

# Set environment settings - Seetting current workspace (geodatabase with feature layers)
arcpy.env.workspace = 'X:\The University of the West Indies\DataGroup - repo_data\data_p145\version01\1-input\GIS Data\Grenada_GIS\Gren_Walk.gdb'
arcpy.env.qualifiedFieldNames = False

# Overwrite outputs of geoprocessing operations
arcpy.env.overwriteOutput = True

# Adding results of geoprocessing operations to display
arcpy.env.addOutputsToMap = True

# Activating Spatial Analyst Extension
arcpy.CheckOutExtension("Spatial")

# Activating Geostatistical Analyst Extension
arcpy.CheckOutExtension("Geostats")

# Activating Network Analyst Extension
arcpy.CheckOutExtension("Network")

# --------------------------------------------------------------------------------

# Set local variables
out_folder_path = "X:\The University of the West Indies\DataGroup - repo_data\data_p145\version01\1-input\GIS Data\Grenada_GIS"
out_name = "Gren_Walk.gdb"

datapath = "C:\Users\810000689\Documents\ArcGIS\Default.gdb"

#Features 
inFeatures = ["ED_SES", "parish1"]
outlocation = 'X:\The University of the West Indies\DataGroup - repo_data\data_p145\version01\1-input\GIS Data\Grenada_GIS\Gren_Walk.gdb'

# Create File Geodatabase
arcpy.CreateFileGDB_management(out_folder_path, out_name)

# Importing Features to File Geodatabase
arcpy.FeatureClassToGeodatabase_conversion(inFeatures, outlocation)


print ("Script Completed")

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------


# Note the below syntax pertains to applications to QGIS python counsel. 

# MAC path

ED = "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145/version01/1-input/GIS Data/Grenada_GIS/demographic_data"
iface.addVectorLayer(ED, "Enumeration District", "ogr")

Road = "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145/version01/1-input/GIS Data/Grenada_GIS/roads2"
iface.addVectorLayer(Road, "Road", "ogr")

Building = "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145/version01/1-input/GIS Data/Grenada_GIS/buildings_new"
iface.addVectorLayer(Building, "Building_land_use", "ogr") 