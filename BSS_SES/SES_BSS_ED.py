
# SCRIPT-FILE METADATA
# Program:	     SES_BSS_ED.py
# Project:	     Macroscale Walkability - PhD
# Analyst:	     Kern Rocke
# Date Created:	 11/11/2019
# Date Modified: 12/11/2019
# Algoithm Task: Creating File Geodatabase for SES Ennumeration Mapping

#Import system modules
import arcpy

# Set environment settings - Seetting current workspace (geodatabase with feature layers)
arcpy.env.workspace = 'C:\Users\810000689\Documents\ArcGIS\Default.gdb'
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
out_folder_path = "C:\Users\810000689\The University of the West Indies\DataGroup - repo_data\data_p145\version01\1-input\GIS Data"
out_name = "SES_BSS_ED.gdb"

datapath = "C:\Users\810000689\Documents\ArcGIS\Default.gdb"

#Features 
inFeatures = ["ED_SES", "parish1"]
outlocation = 'C:\Users\810000689\The University of the West Indies\DataGroup - repo_data\data_p145\version01\1-input\GIS Data\SES_BSS_ED.gdb'

# Create File Geodatabase
arcpy.CreateFileGDB_management(out_folder_path, out_name)

# Importing Features to File Geodatabase
arcpy.FeatureClassToGeodatabase_conversion(inFeatures, outlocation)

#Creating Layer for Health of the Nation sampled EDs
HoTN_query = arcpy.SelectLayerByAttribute_management("ED_SES", "NEW_SELECTION", 'ENUM_NO1 in (2, 12, 25, 37, 51, 63, 74, 86, 101, 111, 120, 132, 149, 159, 172, 193, 206, 217, 229, 244, 258, 270, 282, 298, 310, 322, 334, 340, 354, 368, 381, 395, 405, 431, 445, 459, 472, 485, 500, 509, 520, 533, 546, 562, 579)')
arcpy.MakeFeatureLayer_management("ED_SES", "HoTN_ED", HoTN_query)
arcpy.CopyFeatures_management(HoTN_query)

#Creating Layer for ECHORN sampled EDs
ECHORN_query = arcpy.SelectLayerByAttribute_management("ED_SES", "NEW_SELECTION", 'ENUM_NO1 in (15, 32, 49, 98, 118, 133, 155, 166, 181, 196, 211, 224, 241, 257, 273, 290, 309, 324, 346, 363, 379, 396, 408, 422, 436, 455, 469, 486, 504, 517, 536, 556, 581)')
arcpy.MakeFeatureLayer_management("ED_SES", "ECHORN_ED", ECHORN_query)
arcpy.CopyFeatures_management(ECHORN_query)

# Import SES Excel Data to geodatabase
arcpy.ExcelToTable_conversion("SES_data.xlsx", "SES_BSS_ED.gdb", "Sheet1")

# -------------------------------------------------------------------------------------

# JOINING SES Excel Data to ED layer

# Create workspace variable
workspace = 'C:\Users\810000689\Documents\ArcGIS\Default.gdb'

edit = arcpy.da.Editor(workspace)

# Start the edit session
edit.startEditing(True)

# Start an edit operation
edit.startOperation()

# Join SES data to ED layer
arcpy.AddJoin_management('ED_SES', 'ENUM_NO1','SES_data', 'OBJECTID')

# Start an edit operation
edit.stoptOperation()

# Start the edit session
edit.stopEditing(True)

