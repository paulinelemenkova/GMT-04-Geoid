#!/bin/sh
# Purpose: geoid of Venezuela
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert
# http://soliton.vm.bytemark.co.uk/pub/cpt-city/kst/tn/33_blue_red.png.index.html

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

gmt grdconvert s45w90/w001001.adf geoid_01.grd
gdalinfo geoid_01.grd -stats
# Minimum=-28.476, Maximum=50.095, Mean=7.756, StdDev=14.446


# Generate a color palette table from grid
# gmt makecpt --help
# gmt makecpt -C25_mac_style.cpt -T-55/25 > colors.cpt
gmt makecpt -Chaxby.cpt -T-10/51 > colors.cpt
#-Ic Reverse sense of color table spectrum
# haxby

# Generate a file
ps=Geoid_BO.ps
gmt grdimage geoid_01.grd -Ccolors.cpt -R290/302.5/-23/-9 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_01.grd -R -J -C1.0 -A2.0+f8p,0,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx4f2a2 -Bpyg4f2a2 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=13p,25,black \
    -B+t"Geoid model (EGM-2008) of Bolivia" -O -K >> $ps
    
# Add legend
gmt psscale -Dg290/-23.8+w16.0c/0.4c+h+o0.0/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=8p,25,black \
    -Bg2f0.2a4+l"Color scale '33_blue_red': colour tables of IDL from the KDE scientific plotting tool [256, discrete, RGB, 252 segments, -T-55/25]" \
    -I0.2 -By+lm -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx13.5c/-2.3c+c50+w200k+l"Mercator projection. Scale (km)"+f \
    -UBL/-5p/-65p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thick,brown -Wthick,darkslategray -Df -O -K >> $ps

# Texts

# Add GMT logo
gmt logo -Dx6.2/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X1.2c -Y10.8c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
1.5 13.6 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_BO.ps -A1.0c -E720 -Tj -Z
