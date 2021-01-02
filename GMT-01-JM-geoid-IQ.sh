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

gmt grdconvert n00e45/w001001.adf geoid_IR.grd
gmt grdconvert n00e00/w001001.adf geoid_IQ.grd
gdalinfo geoid_IQ.grd -stats
# Minimum=-106.909, Maximum=22.126
gdalinfo geoid_IQ.grd -stats
# Minimum=-43.581, Maximum=54.907


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Chaxby -T-20/40/1 > colors.cpt
gmt makecpt -Chaxby -T-20/40/1 > colors1.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_IQ.ps
gmt grdimage geoid_IR.grd -Ccolors1.cpt -R38/49/29/38 -JM6.5i -P -Xc -K > $ps
gmt grdimage geoid_IQ.grd -Ccolors.cpt -R -J -P -Xc -O -K >> $ps
#-I+a15+ne0.75

# Add shorelines
gmt grdcontour geoid_IR.grd -R -J -C1 -A1+f9p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_IQ.grd -R -J -C1 -A1+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg2f1a2 -Bpyg2f1a2 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=7p,25,black \
    --FONT_LABEL=8p,25,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational model of Iraq" \
    -Lx14.0c/-2.5c+c318/-57+w200k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg38.0/28.3+w16.0c/0.15i+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=6p,Helvetica,black \
    -Bg5f1a10+l"Color scale: haxby for geoid & gravity [R=-107/23/1, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,purple -Wthinner -Df -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-55 >> $ps << EOF
46.2 32.4 Tigris
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-15 >> $ps << EOF
44.7 31.1 Euphrates
EOF
#
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,blue2+jLB >> $ps << EOF
42.5 32.7 Buhayrat
42.5 32.5 Ar Razazah
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,blue2+jLB >> $ps << EOF
42.6 33.3 Lake
42.6 33.1 Habbaniyah
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,blue2+jLB >> $ps << EOF
43.3 34.2 Buhayrat
43.3 34.0 ath-Tharthar
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB >> $ps << EOF
48.1 29.6 Persian
48.3 29.3 Gulf
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,13,black+jLB -Gwhite@30 >> $ps << EOF
44.1 33.1 Baghdad
EOF
gmt psxy -R -J -Ss -W0.5p -Gred -O -K << EOF >> $ps
44.0 33.0  0.4c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
43.1 36.1 Mosul
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
43.0 36.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
47.1 30.1 Basra
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
47.0 30.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
44.1 35.1 Kirkuk
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
44.0 35.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
44.1 36.1 Erbil
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
44.0 36.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
44.1 32.1 Najaf
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
44.2 32.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
44.3 32.5 Karbala
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
44.2 32.4 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
45.1 35.1 Sulaymaniya
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
45.0 35.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
46.1 31.1 Al Nasiriya
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
46.0 31.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
46.8 30.7 Al Amarah
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
47.0 31.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,red+jLB >> $ps << EOF
46.5 36.5 I R A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,red+jLB >> $ps << EOF
39.0 30.5 S A U D I  A R A B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,white+jLB >> $ps << EOF
38.5 35.5 S Y R I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,red+jLB >> $ps << EOF
38.1 32.4 JORDAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,white+jLB >> $ps << EOF
39.0 37.5 T U R K E Y
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f17p,25,purple+jLB >> $ps << EOF
41.8 33.5 I      R      A      Q
EOF

# Add GMT logo
gmt logo -Dx7.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y10.8c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
2.5 9.3 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_IQ.ps -A0.5c -E720 -Tj -Z
