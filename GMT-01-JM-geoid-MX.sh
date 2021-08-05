#!/bin/sh
# Purpose: geoid of Mexico
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

gmt grdconvert n00w135/w001001.adf geoid_01.grd
gmt grdconvert n00w90/w001001.adf geoid_02.grd
gdalinfo geoid_01.grd -stats
# Min=-28.476 Max=50.095
gdalinfo geoid_02.grd -stats
# Min=-70.856 Max=32.958


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Chaxby -T-50/10 > colors.cpt
# gmt makecpt -Cwysiwyg -T-20/30 > colors.cpt
#-Ic Reverse sense of color table spectrum
# haxby

# Generate a file
ps=Geoid_MX.ps
gmt grdimage geoid_01.grd -Ccolors.cpt -R240/275/14/33 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps
gmt grdimage geoid_02.grd -Ccolors.cpt -R240/275/14/33 -JM6.5i -P -Xc -I+a15+ne0.75 -O -K >> $ps

# Add shorelines
# Add shorelines
gmt grdcontour geoid_01.grd -R -J -C1.0 -A2.0+f9p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_02.grd -R -J -C1.0 -A2.0+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx4f2a4 -Bpyg8f4a4 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=16p,25,black \
    -B+t"Geoid model (EGM-2008) of Mexico" -O -K >> $ps
    
# Add legend
gmt psscale -Dg240/11.7+w16.5c/0.4c+h+o0.0/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=8p,25,black \
    -Bg2.5f0.5a5+l"Color scale 'haxby': B. Haxby's color scheme for geoid & gravity [C=RGB, -T-50/10]" \
    -I0.2 -By+l"m" -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.8c/-2.3c+c50+w500k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-70p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thicker,white -Wthinner,yellow -Df -O -K >> $ps

# Texts

# Add GMT logo
gmt logo -Dx7.5/-2.8+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y0.8c -N -O \
    -F+f12p,25,black+jLB >> $ps << EOF
1.5 14.5 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_MX.ps -A1.0c -E720 -Tj -Z
