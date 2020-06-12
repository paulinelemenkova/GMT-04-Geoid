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
gdalinfo as_geoid.nc -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chaxby -T-104/-2/1 > colors.cpt

grdcut geoid.egm96.grd -R47/77/0/31 -Gas_geoid.nc

# Generate a file
ps=Geoid_AS.ps
# Make raster image
# Generate geoid image with shading
#gmt grdimage geoid.egm96.grd -I+a45+nt1 \
 #   -R47/77/0/31 -JT62/15/6i -Ccolors.cpt -P -K > $ps
gmt grdimage as_geoid.nc -I+a45+nt1 \
    -R47/77/0/31 -JT62/15/6i -Ccolors.cpt -P -K > $ps
# makecpt --help

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg2.5 -Bsyg2.5 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Geoid regional model: Arabian Sea region" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx12.6c/14.0c+w0.3i+f2+l+o0.15i \
    -Lx12c/-2.5c+c50+w800k+l"Transverse Mercator projection. Scale: km"+f \
    -UBL/-5p/-70p -O -K >> $ps
    
# Add color legend
gmt psscale -Dg47/-2.5+w15.0c/0.4c+h+o0.3/0i+ml -R47/77/0/31 -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale: Haxby: Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lmGal -O -K >> $ps

# Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C6 -A12 -Wthinnest,dimgray -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-3.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.5 15.1 World geoid image 2 min, version 9.2 EGM96
1.7 14.6 Transverse Mercator prj. Central meridian: 62\232E Standard parallel: 15\232N
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert Geoid_AS.ps -A1.5c -E720 -Tj -Z
