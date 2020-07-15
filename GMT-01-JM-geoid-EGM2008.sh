#!/bin/sh
# Purpose: convert ESRI GRID file to GMT from folder
# http://gmt.soest.hawaii.edu/boards/1/topics/2732
# GMT modules: grdconvert
# пробел после / обязателен
# EGM2008 2.5 Minute Geoid Undulation Grid - Middle East, https://earth-info.nga.mil/GandG/wgs84/gravitymod/egm2008/egm08_gis.html

# 'cent2_geoid/' - папка с ESRI GRDI файлами
grdconvert EGM2008World/ EGM2008.grd

#grdconvert EGM2008ME.grd -GEGM2008ME.nc
gdalinfo EGM2008.grd -stats
# Minimum=-66.798, Maximum=20.214

gmt makecpt -Chaxby -T-107/47/1 > colors.cpt

# Generate a file
ps=Geoid_EGM2008.ps
gmt grdimage EGM2008.grd -Ccolors.cpt -R20/90/-5/60 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -B+t"EGM2008 Geoid gravitational regional model: Java and Sumatra region" \
    -Lx12.7c/-1.3c+c318/-57+w800k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Add shorelines
gmt grdcontour EGM2008.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
2.5 19.0 World geoid image EGM2008 vertical datum resolution 2.5 min
EOF

# Add GMT logo
gmt logo -Dx6.2/-7.8+o0.1i/0.1i+w2c -O >> $ps
    
# compare to EGM96:
# gmt grdimage geoid.egm96.grd -Ccolors.cpt -R20/90/-5/60 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
# Convert to image file using GhostScript
gmt psconvert Geoid_EGM2008.ps -A1.0c -E720 -Tj -Z
