#!/bin/sh
# Purpose: geoid of Iraq
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

gmt grdconvert n00e00/w001001.adf geoid_IQ.grd
gdalinfo geoid_IQ.grd -stats
# Min=-43.581 Max=54.907


# Generate a color palette table from grid
# gmt makecpt --help
#gmt makecpt -Chaxby -T-44/55/1 > colors.cpt
gmt makecpt -Cwysiwyg -T0/40/1 > colors.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_JO.ps
gmt grdimage geoid_IQ.grd -Cwysiwyg -R34/40/29/34 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_IQ.grd -R -J -C0.25 -A1+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg1f0.5a1 -Bpyg1f0.5a1 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=8p,25,black \
    --FONT_LABEL=8p,25,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational model of Jordan" \
    -Lx14.0c/-2.5c+c318/-57+w100k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg33.9/28.6+w16.5c/0.15i+h+o0.3/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=8p,Helvetica,black \
    -Bg5f0.5a5+l"Color scale wysiwyg: 20 well-separated RGB colors [C=RGB, -T0/40/1]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,purple -Wthinner -Df -O -K >> $ps

# Texts

# Add GMT logo
gmt logo -Dx7.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y10.8c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
2.5 9.3 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_JO.ps -A0.5c -E720 -Tj -Z
