#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Peru-Chile Trench).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_PCT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=0.5c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.7c \
    FONT_TITLE=14p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
# Step-3. Generate a color palette table from grid
gmt grd2cpt geoid.egm96.grd -Crainbow > geoid.cpt
# Step-4. Generate geoid image with shading
grdcut geoid.egm96.grd -R270/300/-55/0 -Gpct_geoid.nc
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R270/300/-55/0 -JM4.5i -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid regional model: Peru-Chile Trench area" \
	-Bxg3f4a4 -Byg3f2a4 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C2 -A5 -Wthinnest,dimgray -O -K >> $ps
# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=9p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx10c/-2.6c+c50+w600k+l"Mercator Cylindrical projection. Scale, km"+f \
    -UBL/-15p/-80p -O -K >> $ps
# Step-8. Add magnetic rose
gmt psbasemap -R -J \
    --FONT=6p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=5p \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_TICK_PEN_PRIMARY=thinnest,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Tmg277/-50+w3.4c+d-14.5+t45/10/5+ithin,blue+p0.1p,red+l+jCM \
    -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.0c/-2.0c+w12c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# Step-11. Add logo
gmt logo -R -J -Dx4.0/-3.8+o0.1i/0.1i+w2c -O >> $ps
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_PCT.ps -A1.2c -E720 -Tj -Z
