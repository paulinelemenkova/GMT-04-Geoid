#!/bin/sh
# Purpose: World geoid image 15 min, version 9.2 EGM96 global data set (here: Scotia Sea)
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

gmt grdcut geoid.egm96.grd -R270/371/-72/-44 -Gss_geoid.nc

# Generate a color palette table from grid
# makecpt --help
gdalinfo ss_geoid.nc -stats
# Minimum=-20.105, Maximum=28.886
gmt makecpt -Chaxby -T-20.105/28.886/1 > colors.cpt

# Generate a file
ps=Geoid_SS.ps
gmt grdimage ss_geoid.nc -Ccolors.cpt -R270/-65/340/-45r -JA318/-57/5.5i -P -I+a15+ne0.75 -Xc -K > $ps

# Add shorelines
gmt grdcontour ss_geoid.nc -R -J -C1 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a10 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_FRAME_AXES=wESN \
    --MAP_TITLE_OFFSET=1.5c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -B+t"Geoid gravitational regional model: Scotia Sea" \
    -Lx12.0c/-1.4c+c318/-57+w1000k+l"Scale (km) at 42\232W 57\232S"+f \
    -O -K >> $ps

# Add legend
gmt psscale -Dg269/-68+w10.0c/0.4c+v+o-7.0c/-5.3c+ml -R270/340/-65/-45 -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Bg5f1a5 \
    -I0.2 -By+lm -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
#2.1 7.4 ETOPO1 global terrain model, 1 arc min resolution grid
1.0 7.4 World geoid image 15 min, version 9.2 EGM96 (Lemoine et al. 1998)
0.0 6.8 Lambert Azimuthal Equal-Area projection. Central meridian 42\232W, parallel 57\232S
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_SS.ps -A0.5c -E720 -Tj -Z
