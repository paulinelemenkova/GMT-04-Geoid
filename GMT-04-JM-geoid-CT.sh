#!/bin/sh
# Purpose: shaded relief grid raster map from the ETOPO1 from 1 arc minute global data set (here: Cascadia Trench)
# GMT modules: gmtset, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
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
FONT_LABEL=7p,Helvetica,dimgray \

# Extract a subset for the Cascadia Trench area
grdcut geoid.egm96.grd -R224/240/35/55 -Gct_geoid.nc
gdalinfo ct_geoid.nc -stats
#Minimum=-40.554, Maximum=-2.894

# Make color palette
gmt makecpt -Chaxby -T-41/-2/1 > colors.cpt

# Generate a file
ps=GeoidCT.ps
# Make raster image
gmt grdimage ct_geoid.nc -Ccolors.cpt -R224/240/35/55 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg8f2a4 -Bpyg6f2a2 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,dimgray \
    --MAP_ANNOT_OFFSET=0.1c \
    -B+t"Geoid gravitational regional model: Cascadia Trench" -O -K >> $ps
    
# Add legend
gmt psscale -Dg217/35+w15.0c/0.4c+h+o7.0/-1.5c+ml -Rct_relief.nc -J -Ccolors.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=5p,Helvetica,dimgray \
    -Baf+l"Color scale: haxby (B. Haxby's color scheme for geoid & gravity [C=RGB] -41/-2)" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add shorelines
gmt grdcontour ct_geoid.nc -R -J -C1 -A5 -Wthinnest,dimgray -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx1.0c/1.3c+w0.3i+f2+l+o0.15i \
    -Lx13.4c/-2.7c+c50+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/0p/-75p -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx6.4/-3.5+o0.1i/0.1i+w2c -O -K >> $ps


# Add subtitle
gmt pstext -R0/10/0/15 -JX10/14 -X0.5c -Y7.1c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
#3.0 22.3 World geoid image 2 min, version 9.2 EGM96
4.0 22.5 EGM2008 2.5 Minute Interpolation Grid
EOF

# Convert to image file using GhostScript
gmt psconvert GeoidCT.ps -A2.5c -E720 -Tj -Z
