#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: New Britain - San Cristobal trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_NBT.ps
# Step-2. GMT set up
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
# Step-3. Generate a color palette table from grid
gmt grd2cpt geoid.egm96.grd -Crainbow -V -T-10/80 > geoid.cpt
# Step-4. Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R140/162/-15/0 -JM16c -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid regional model: New Britain and San Cristobal trenches area" \
	-Bxg3f4a4 -Byg3f2a4 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C1 -A2 -Wthinnest,dimgray -O -K >> $ps
# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx14c/-2.6c+c50+w500k+l"Mercator projection. Scale, km"+f \
    -UBL/-5p/-80p -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.0c/-2.0c+w12c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# Step-11. Add logo
gmt logo -R -J -Dx7.0/-3.5+o0.1i/0.1i+w2c -O >> $ps
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_NBT.ps -A1.0c -E720 -Tj -Z
