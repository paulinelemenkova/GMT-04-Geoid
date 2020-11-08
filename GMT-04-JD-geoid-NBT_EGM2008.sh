#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: New Britain - San Cristobal trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=0.3c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.7c \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
    
# 'cent2_geoid/' - папка с ESRI GRDI файлами
grdconvert s45e135/ EGM2008nbt.grd

gdalinfo EGM2008nbt.grd -stats
#  Minimum=-21.515, Maximum=85.824

# Make color palette
#gmt makecpt -Chaxby -T-22/86/1 > colors.cpt
#gmt makecpt -Cturbo -T-22/86/1 > colors.cpt

# Generate a file
ps=Geoid_NBT2008.ps

# Generate geoid image with shading
#gmt grdimage EGM2008nbt.grd -I+a45+nt1 \
    -R140/162/-15/0 -JM16c -Ccolors.cpt -P -K > $ps
gmt grdimage EGM2008nbt.grd -I+a45+nt1 \
    -R140/162/-15/0 -JM16c -Chaxby -P -K > $ps

# Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    -Df -B+t"Geoid regional model: New Britain and San Cristobal trenches area" \
	-Bxg4f4a4 -Byg4f2a4 \
    -O -K >> $ps
    
# Add geoid contour
gmt grdcontour EGM2008nbt.grd -R -J -C1 -A2 -Wthinnest,dimgray -O -K >> $ps

# Add scale
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx14c/-2.6c+c50+w500k+l"Mercator projection. Scale, km"+f \
    -UBL/-5p/-80p -O -K >> $ps
    
# Add color legend
gmt psscale -R -J -Ccolors.cpt\
    -DjBC+o0.0c/-2.0c+w16c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Bg5f1a10+l"Color scale: B. Haxby's color scheme for geoid & gravity [C=RGB] -22/86/1" \
    -I0.2 -By+lm -O -K >> $ps
    
    -Bg500f100a1000

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/14 -X0.5c -Y7.1c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 5.0 Global geoid image EGM2008-WGS84 2,5 minute resolution
EOF
    
# Add logo
gmt logo -R -J -Dx6.5/-10.5+o0.1i/0.1i+w2c -O >> $ps

# Convert to image file using GhostScript
gmt psconvert Geoid_NBT2008.ps -A1.0c -E720 -Tj -Z
