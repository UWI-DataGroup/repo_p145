
##  META-DATA
##  Program:		Gren_Walk_001
##  Project:      	Macroscale Walkability- PhD
##	Sub-Project:	Walkability Computation - Grenada 
##  Analyst:		Kern Rocke
##	Date Created:	12/01/2019
##	Date Modified: 	12/01/2019
##  Algorithm Task: Importing Grenada Shapefiles

# MAC

ED = "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145/version01/1-input/GIS Data/Grenada_GIS/demographic_data"
iface.addVectorLayer(ED, "Enumeration District", "ogr")