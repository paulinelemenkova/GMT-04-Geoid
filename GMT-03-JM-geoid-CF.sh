#!/bin/sh
# Purpose: geoid of Panama
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert
# http://soliton.vm.bytemark.co.uk/pub/cpt-city/kst/tn/25_mac_style.png.index.html

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

exec bash

gmt grdconvert n00e00/w001001.adf geoid_CF.grd
gdalinfo geoid_CF.grd -stats
# actual_range={-43.58100128173828,54.90700149536133}

# Generate a color palette table from grid
#gmt makecpt -C25_mac_style.cpt -T-16/18 > colors.cpt
#gmt makecpt -C25_mac_style.cpt -T-16/18 > colors.cpt
gmt makecpt -Cjet.cpt -T-18/18 > colors.cpt
#-Ic Reverse sense of color table spectrum
# gmt makecpt --help

# Generate a file
ps=Geoid_CF.ps
gmt grdimage geoid_CF.grd -Ccolors.cpt -R14/28/2.5/11.5 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_CF.grd -R -J -C0.5 -A1.0+f8p,0,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx1f1a1 -Bpyg1f1a1 -Bsxg1 -Bsyg1 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=13p,25,black \
    -B+t"Earth geoid model on Central African Republic" -O -K >> $ps
    
# Add legend
gmt psscale -Dg14/1.5+w16.0c/0.15i+h+o0.3/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_TITLE=8p,25,black \
    -Bg2f0.2a4+l"Color scale 'jet': dark to light blue, white, yellow and red [C=RGB], -T-18/18]" \
    -I0.2 -By+lm -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.5c/-2.3c+c50+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/-0p/-70p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thick,white -Wthick,darkslategray -Df -O -K >> $ps

# Add GMT logo
gmt logo -Dx7.0/-3.1+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y4.5c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
3.0 10.4 Earth geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_CF.ps -A1.0c -E720 -Tj -Z
