#!/bin/sh
# Purpose: geoid of Ethiopia
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

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
    FONT_LABEL=7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

gmt grdconvert s45e00/w001001.adf geoid_TZ.grd
gdalinfo geoid_TZ.grd -stats
# Minimum=-43.794, Maximum=47.399


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Chaxby -T-30/0/1 > colors.cpt
#gmt makecpt -Chaxby -T-20/40/1 > colors1.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_MW.ps
gmt grdimage geoid_TZ.grd -Ccolors.cpt -R32/36/-17.5/-9 -JM5.0i -P -Xc -K > $ps
#-I+a15+ne0.75

# Add shorelines
gmt grdcontour geoid_TZ.grd -R -J -C0.5 -A1+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg2f1a0.5 -Bpyg2f1a1 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=7p,25,black \
    --FONT_LABEL=8p,25,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational model of Malawi" \
    -Lx11.0c/-2.5c+c318/-57+w50k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg32/-17.9.0+w12.0c/0.15i+h+o0.3/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg5f1a5+l"Color scale: haxby for geoid & gravity [R=-107/23/1, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,purple -Wthinner -Df -O -K >> $ps

# Texts

# Add GMT logo
gmt logo -Dx5.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y21.5c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
0.5 10.3 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_MW.ps -A3.5c -E720 -Tj -Z
