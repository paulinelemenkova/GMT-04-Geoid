#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Izu-Bonin Trench).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_IBT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=1.0c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.7c \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
# Step-3. Generate a color palette table from grid
gmt grd2cpt geoid.egm96.grd -Chaxby -V -T-0/100 > geoid.cpt
# Step-4. Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R128/150/20/36 -JM16c -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid regional model: Japan and Izu-Bonin Trench area" \
	-Bxg3f4a4 -Byg3f2a4 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C1 -A2 -Wthinnest,dimgray -O -K >> $ps
# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_ANNOT_OFFSET=0.0c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx14c/-2.6c+c50+w500k+l"Mercator projection. Scale, km"+f \
    -UBL/-5p/-80p -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.0c/-2.0c+w12c/0.5c+h\
    --FONT_LABEL=8p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,navy+jLB >> $ps << EOF
145.8 33.0 PACIFIC OCEAN
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB >> $ps << EOF
130 32.5 KYUSHU
134.0 35.0 HONSHU
135.8 29.5 SHIKOKU BASIN
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,gold+jLB+a-254 >> $ps << EOF
144.2 27.5 I  z  u - B  o  n  i  n
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,gold+jLB+a-265 >> $ps << EOF
142.8 31.9 T  r  e  n  c  h
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB  >> $ps << EOF
142.3 35.0 Boso Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB+a-300 >> $ps << EOF
131.4 28.5 Nankai
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB+a-317 >> $ps << EOF
133.2 30.7 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB+a-340 >> $ps << EOF
135 32.0 Suruga
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB+a-325 >> $ps << EOF
137.2 32.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,darkblue+jLB+a-20 >> $ps << EOF
139.7 34.3 Sagami
139.7 33.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,gold+jLB+a-80 >> $ps << EOF
141.8 28.7 Bonin Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-44 >> $ps << EOF
144.6 23.7 Mariana
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-62 >> $ps << EOF
146.9 21.6 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB+a-80 -Gwhite@30 >> $ps << EOF
140.3 33.0 I  Z  U - B  O  N  I  N   V  O  L  C  A  N  I  C   A  R  C
EOF
# Step-11. Add logo
gmt logo -R -J -Dx7.0/-3.5+o0.1i/0.1i+w2c -O -K >> $ps
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 11.0 Data source: EGM96 geoid reference. Color palette: Bill Haxby's scheme for geoid & gravity [C=RGB]
EOF
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_IBT.ps -A1.0c -E720 -Tj -Z
