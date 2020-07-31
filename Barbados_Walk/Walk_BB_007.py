
##  GENERAL DO-FILE COMMENTS
##  Program:		Walk_BB_007.py
##  Project:      	Macroscale Walkability- PhD
##	Sub-Project:	Walkability Index Computation
##  Analyst:		Kern Rocke
##	Date Created:	29/07/2020
##	Date Modified: 	30/07/2020
##  Algorithm Task: Creating Walkability Attributes Layer


# -*- coding: utf-8 -*-
"""
Generated by ArcGIS ModelBuilder on : 2020-07-29 15:32:53
"""
import arcpy

def WalkabilityExport():  # Walkability Export

    # To allow overwriting outputs change overwriteOutput option to True.
    arcpy.env.overwriteOutput = False

    arcpy.ImportToolbox(r"c:\program files\arcgis\pro\Resources\ArcToolbox\toolboxes\Conversion Tools.tbx")
    Intersection_Density_Final = "Intersection Density Final"
    Enumeration_District = "\\\\Mac\\Home\\Desktop\\Walkability\\Walkability.gdb\\ED_Boundary_2010"
    Land_Use_Mix = "Land_Use_Mix_Layer"
    Residential_Density_Final = "Residential Density Final"

    # Process: Delete Field (Delete Field) 
    Intersection_Density_Final_Cleaned_ = arcpy.DeleteField_management(in_table=Intersection_Density_Final, drop_field=["ABOVE_KNEE", "ADVENTIST", "AF_CONF", "ANGLICAN", "ARAB", "Area", "ARRANGEMEN", "ASPHALT_SH", "ASTHMA", "ATTENDING_", "BAHAI", "BAPTIST", "BARBADOS_B", "BATTERIES", "BELOW_KNEE", "BLACK", "BLINDNESS", "BRETHEREN", "CABLE_TVSA", "CANE", "CANT_CARE_", "CANT_CLIMB", "CANT_SPEAK", "CANT_WALK", "CHINESE", "CHURCH_OF_", "CLOTHES_DR", "COMMERCIAL", "COMPLETED", "COMPUTER", "CONCRETE", "CONCRETE_1", "CONCRETE_B", "CORR_METAL", "CRIME_VICT", "CRUTCHES", "DEAFNESS", "Density", "DERELICT", "DIABETES", "DID_NOT_WO", "DISH_WASHE", "DIVORCED", "DOCTOR_DIA", "DOOE_FREEZ", "DOUBLE_AMP", "DVD_PLAYER", "EAST_INDIA", "ELECTICITY", "ELECTRIC", "ELECTRIC_G", "EMIGRANTS", "EVER_HAD_C", "F0_49999YEA", "F0BATHROOMS", "F0BEDROOMS", "F0VEHICLE", "F100000_149", "F150000_199", "F1990BEFORE", "F1991_1999", "F1BATHROOM", "F1BEDROOM", "F1PERSON", "F1ROOM", "F1VEHICLE", "F2000_2003", "F200000YEAR", "F2004_2007", "F2008_1", "F2009_1", "F2010_1", "F2BATHROOM", "F2BEDROOMS", "F2PERSONS", "F2ROOMS", "F2VEHICLE", "F3BATHROOMS", "F3BEDROOMS", "F3PERSONS", "F3ROOMS", "F3VEHICLE", "F4BEDROOMS", "F4PERSONS", "F4ROOMS", "F4VEHICLEMO", "F50000_9999", "F5MOREBEDRO", "F5PERSONS", "F5ROOMS", "F6PERSONS", "F6ROOMS", "F7PERSONS", "F7ROOMS", "F8PERSONSMO", "F8ROOMS", "F9MOREROOMS", "FEMALE", "FID_Road_Unsplit", "FIXED_LINE", "FLAT_APT", "FLATAPT_WR", "FOR_RENT", "FOR_RENTSA", "FOR_SALE", "FRIEND_PIP", "GAS", "GOVERNMENT", "GOVRENT_HO", "GOVRENT_LA", "GROUP_DW_1", "GROUP_DWEL", "HAS_INTERN", "HEARING_IM", "HEART_DISE", "HIGHEST__1", "HIGHEST__2", "HIGHEST_NO", "HIGHEST_OT", "HIGHEST_PO", "HIGHEST_PR", "HIGHEST_SE", "HIGHEST_TE", "HINDU", "HOME_DUTIE", "HYPERTENSI", "ID3", "INCAPACITA", "INTELLECTU", "INTERNETCA", "INTERNETCE", "INTERNETFA", "INTERNETHO", "INTERNETLI", "INTERNETOT", "INTERNETWO", "JEHOVAH_WI", "JEWISH", "Join_Count", "Join_Count_1", "KEROSENE", "KEROSENE_1", "KIDNAPPING", "KIDNEY_DIS", "LARCENY", "LEARNING_D", "LOOKED_FOR", "LOW_LIMB_D", "LPG", "MAINACT_OT", "MALES", "MARRIED", "MENTAL_ILL", "METHODIST", "MICROWAVE", "MIXED", "MORAVIAN", "MORMON", "MURDER", "MUSLIM", "NATURAL_GA", "NEVER_MARR", "NO_DISABIL", "NO_DISEASE", "NO_RELIGIO", "NO_SCHOOL", "NO_TOILET", "NUM_BIRT_1", "NUM_BIRT_2", "NUM_BIRT_3", "NUM_BIRT_4", "NUM_BIRTHS", "OCCUPIED", "OTHER_ARRA", "OTHER_CHRI", "OTHER_CRIM", "OTHER_DISA", "OTHER_DISE", "OTHER_ETHN", "OTHER_HO_1", "OTHER_HOUS", "OTHER_LAND", "OTHER_LIGH", "OTHER_META", "OTHER_NON_", "OTHER_PIPE", "OTHER_ROOF", "OTHER_TOIL", "OTHER_WALL", "OTHER_WATE", "OTHERSCHOO", "OWNED_HOUS", "OWNED_LAND", "P35_OTHER", "PARISHNAM1", "PENTECOSTA", "PIPED_IN_1", "PIPED_INTO", "PIT", "POLY_AREA", "POPULATION", "POSTSECOND", "PREPIRMARY", "PRIVATE_EN", "PRIVATE_HO", "PRIVATER_1", "PRIVATEREN", "RADIO", "RAPEABUSE", "RASTAFARIA", "RD_NAME", "REFRIGERAT", "RELIG_NONE", "RENT_FRE_1", "RENT_FREE_", "RENTED_R_1", "RENTED_ROO", "ROBBERY", "ROMAN_CATH", "ROOFING_TI", "SALVATION_", "SCHOOL_FUL", "SCHOOL_PAR", "SECONDARY", "SEPARATE_1", "SEPARATE_H", "SEPARATED", "SEVERE_ART", "SHARED_BAT", "SHARED_TOI", "SHOOTING", "SOLAR", "SOLAR_WATE", "SOLAROTHER", "STAND_PIPE", "STEREO_SYS", "STONE", "STOVE", "STREAMSPRI", "STUDENT", "TARGET_FID", "TARGET_FID_1", "TERTIARY", "TOASTER_OV", "TOTAL_DWEL", "TOTAL_LI_1", "TOTAL_LI_2", "TOTAL_LI_3", "TOTAL_LI_4", "TOTAL_LI_5", "TOTAL_LI_6", "TOTAL_LI_7", "TOTAL_LI_8", "TOTAL_LI_9", "TOTAL_LI10", "TOTAL_LIVE", "TOWNHOUSE_", "TV", "UNDER_ACTI", "UNDER_INAC", "UNOCCUPIED", "UNPAID_WOR", "UP_LIMB_AM", "UP_LIMB_DE", "VCR", "VISION_IMP", "WALKER", "WASHING_MA", "WATER_TANK", "WC_NO_SEWE", "WC_SEWER", "WHEELCHAIR", "WHITE", "WIDOWED", "WITH_JOB_N", "WITH_PAID_", "WITH_UNPAI", "WOOD", "WOOD_CON_1", "WOOD_CONCR", "WOODCHARCO", "WOODEN_SHI", "WORKED", "WORKED_OTH", "WOUNDING"])[0]

    # Process: Copy Features (Copy Features) 
    Walkability_ED = "\\\\Mac\\Home\\Desktop\\Walkability\\Walkability.gdb\\Walkability_ED"
    arcpy.CopyFeatures_management(in_features=Enumeration_District, out_feature_class=Walkability_ED, config_keyword="", spatial_grid_1=None, spatial_grid_2=None, spatial_grid_3=None)

    # Process: Add Join (Street Connectivity) (Add Join) 
    Walkability_ED_Street = arcpy.AddJoin_management(in_layer_or_view=Intersection_Density_Final_Cleaned_, in_field="ENUM_NO1", join_table=Walkability_ED, join_field="ENUM_NO1", join_type="KEEP_ALL")[0]

    # Process: Add Join (Land Use Mix) (Add Join) 
    Walkability_ED_Street_LUM = arcpy.AddJoin_management(in_layer_or_view=Walkability_ED_Street, in_field="Walkability_ED.ENUM_NO1", join_table=Land_Use_Mix, join_field="Land_Use_Mix.ENUM_NO1", join_type="KEEP_ALL")[0]

    # Process: Add Join (Residential Density) (Add Join) 
    Walkability_ED_Street_LUM_Res = arcpy.AddJoin_management(in_layer_or_view=Walkability_ED_Street_LUM, in_field="Walkability_ED.ENUM_NO1", join_table=Residential_Density_Final, join_field="ENUM_NO1", join_type="KEEP_ALL")[0]

    # Process: Table To Excel (Table To Excel) 
    Walkability_xls = "\\\\Mac\\Home\\Desktop\\Walkability\\Walkability.xls"
    TableToExcel(Input_Table=Walkability_ED_Street_LUM_Res, Output_Excel_File=Walkability_xls, Use_field_alias_as_column_header="NAME", Use_domain_and_subtype_description="CODE")

if __name__ == '__main__':
    # Global Environment settings
    with arcpy.EnvManager(scratchWorkspace=r"\\Mac\Home\Desktop\Walkability\Walkability.gdb", workspace=r"\\Mac\Home\Desktop\Walkability\Walkability.gdb"):
        WalkabilityExport()