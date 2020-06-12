#!/bin/sh
# Purpose: shaded relief grid raster map from the ETOPO1 from 1 arc minute global data set: Atlantic Ocean
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# 120W 50E 65S 65N

# makecpt --help
# Select a color palette
gdalinfo geoid.egm96.grd -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chaxby -T-107/87/1 > colors.cpt

# Generate a file
ps=Geoid_AO.ps
# Make raster image
# Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R-90/25/-65/65 -JPoly/4i -Ccolors.cpt -P -K > $ps
# makecpt --help

# Add grid
gmt psbasemap -R -J \
    -Bpx20f10a20 -Bpyg20f10a10 -Bsxg10 -Bsyg10 \
    --MAP_TITLE_OFFSET=1.4c \
    -B+t"Geoid regional model: Atlantic Ocean" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.2c \
    -Lx7.8c/-3.7c+c50+w4000k+l"Polyconic prj. Scale: km"+f \
    -UBL/1.0c/-3.7c -O -K >> $ps
    
# Add color legend
gmt psscale -R -J -Ccolors.cpt\
    -DjBC+o0.0c/-3.0c+w8c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C6 -A12 -Wthinnest,dimgray -O -K >> $ps

# Add GMT logo
gmt logo -Dx3.9/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.0 9.3 World geoid image 2 min, version 9.2 EGM96
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert Geoid_AO.ps -A1.5c -E720 -Tj -Z
