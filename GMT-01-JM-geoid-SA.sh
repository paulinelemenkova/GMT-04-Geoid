#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Saudi Arabia)
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

gmt grdconvert n00e45/w001001.adf geoid_SA1.grd
gmt grdconvert n00e00/w001001.adf geoid_SA2.grd
gdalinfo geoid_SA1.grd -stats
#  Minimum=-106.909, Maximum=22.126
gdalinfo geoid_SA2.grd -stats
# Minimum=-43.581, Maximum=54.907


# Generate a color palette table from grid
# gmt makecpt --help
#gmt makecpt -Chaxby -T-107/23/1 > colors.cpt
gmt makecpt -Chaxby -T-100/18/1 > colors.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_SA.ps
gmt grdimage geoid_SA1.grd -Chaxby -R34/60/12/32.5 -JM6.5i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_SA2.grd -Ccolors.cpt -R34/60/12/32.5 -JM6.5i -P -I+a15+ne0.75 -Xc -O -K >> $ps

# Add shorelines
gmt grdcontour geoid_SA1.grd -R -J -C1 -A1+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps
gmt grdcontour geoid_SA2.grd -R -J -C1 -A1+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg2f1a2 -Bpyg2f1a2 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational regional model of Saudi Arabia" \
    -Lx14.0c/-2.5c+c318/-57+w300k+l"Merkator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg34.0/10.0+w16.0c/0.15i+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=6p,Helvetica,black \
    -Bg10f1a5+l"Color scale: haxby for geoid & gravity [R=-107/23/1, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thicker,goldenrod1 -Wthinner -Df -O -K >> $ps

# Add GMT logo
gmt logo -Dx7.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.2c -Y9.0c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
2.8 8.9 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_SA.ps -A0.5c -E720 -Tj -Z
