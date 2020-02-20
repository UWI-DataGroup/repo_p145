clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		Gren_Walk_002.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2020
**	Date Modified: 	20/01/2020
**  Algorithm Task: Walkability Analysis in ArcGIS


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*

GIS Layer obtained from: Caribbean Handbook on Risk Information Management 
GeoNode

Layers:	Road Network
		Building footprint - Land Use
		Enumeration Districts
		Parish

*/

*Open python analysis space
python

# Description: 
# This model describes the walkability index model to be piloted in Grenada for applications in Barbados
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy

# Local variables:
parishes1 = "parishes1"
Grenada_GIS_gdb = "X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS.gdb"
parish = "X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS.gdb\\parish"
roads2_shp = "X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\roads2\\roads2.shp"
Road = roads2_shp
buildings_new_shp = "X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp"
Building = buildings_new_shp
demographic_data_shp = "X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp"
ED = demographic_data_shp

# Process: Feature Class to Feature Class
arcpy.FeatureClassToFeatureClass_conversion(parishes1, Grenada_GIS_gdb, "parish", "", "Name \"Name\" true true false 254 Text 0 0 ,First,#,parishes1,Name,-1,-1", "")

# Process: Feature Class to Feature Class (2)
arcpy.FeatureClassToFeatureClass_conversion(roads2_shp, Grenada_GIS_gdb, "Road", "", "ROAD_NETWO \"ROAD_NETWO\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\roads2\\roads2.shp,ROAD_NETWO,-1,-1", "")

# Process: Feature Class to Feature Class (3)
arcpy.FeatureClassToFeatureClass_conversion(buildings_new_shp, Grenada_GIS_gdb, "Building", "", "BUILDINGS_ \"BUILDINGS_\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,BUILDINGS_,-1,-1;SHAPE_LENG \"SHAPE_LENG\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,SHAPE_LENG,-1,-1;SHAPE_LE_1 \"SHAPE_LE_1\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,SHAPE_LE_1,-1,-1;USE_TYPE \"USE_TYPE\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,USE_TYPE,-1,-1;OCCUPANCY \"OCCUPANCY\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,OCCUPANCY,-1,-1;ED_ID \"ED_ID\" true true false 9 Long 0 9 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,ED_ID,-1,-1;SIZE \"SIZE\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,SIZE,-1,-1;DWELLING \"DWELLING\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\buildings_new\\buildings_new.shp,DWELLING,-1,-1", "")

# Process: Feature Class to Feature Class (4)
arcpy.FeatureClassToFeatureClass_conversion(demographic_data_shp, Grenada_GIS_gdb, "ED", "", "New_ED_ID \"New_ED_ID\" true true false 9 Long 0 9 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,New_ED_ID,-1,-1;Perish \"Perish\" true true false 254 Text 0 0 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Perish,-1,-1;Enum_Dist \"Enum_Dist\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Enum_Dist,-1,-1;HH \"HH\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,HH,-1,-1;Age_0_4 \"Age_0_4\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Age_0_4,-1,-1;Age_5_64 \"Age_5_64\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Age_5_64,-1,-1;Age_65plus \"Age_65plus\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Age_65plus,-1,-1;Male \"Male\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Male,-1,-1;Female \"Female\" true true false 33 Double 31 32 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Female,-1,-1;Pop \"Pop\" true true false 9 Long 0 9 ,First,#,X:\\The University of the West Indies\\DataGroup - repo_data\\data_p145\\version01\\1-input\\GIS Data\\Grenada_GIS\\demographic_data\\demographic_data.shp,Pop,-1,-1", "")


end