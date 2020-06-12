#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Vanuatu and Vityaz Trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_VVT.ps
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
#gmt grdimage geoid.egm96.grd -I+a45+nt1 \
#    -R145/200/-39/0 -JM16c -Cgeoid.cpt -P -K > $ps
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R145/200/-39/0 -JH172/16c -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid model: Fiji region, Eastern Australia, Vanuatu and Vityaz trenches" \
	-Bxg10f5a5 -Byg5f2.5a5 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C1 -A2 -Wthinnest,dimgray -O -K >> $ps
# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=9p,Palatino-Roman,black \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.2c \
    -Lx13c/-2.8c+c50+w1000k+l"Hammer retroazimuthal projection. Scale, km"+f \
    -UBL/2p/-77p -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.0c/-2.0c+w12c/0.5c+h\
    --FONT_LABEL=9p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale. Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lmGal -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f9p,Times-Roman,black+jLB -Gwhite@20 -Wthinnest,darkbrown >> $ps << EOF
175 -38.5 NEW ZEALAND
145.3 -28.0 AUSTRALIA
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,navy+jLB >> $ps << EOF
149.5 -13.5 C O R A L
152.2 -15.5 S E A
190.8 -5.5 P A C I F I C
191.2 -9.2 O C E A N
172.5 -25.5 F I J I  S E A
152.5 -38.5 T A S M A N  S E A
EOF
# gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,lawngreen+jLB+a-290 >> $ps << EOF
182.4 -36 Kermadec Trench
186.5 -24 Tonga Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-32 -Gwhite@30>> $ps << EOF
168 -7.5 Vityaz Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-72 -Gwhite@40 >> $ps << EOF
166.8 -10.5 V a n u a t u  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
176.0 -19.2 FIJI
189.0 -13.8 SAMOA
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Times-Roman,black+jLB+a-39 -Gwhite@30 >> $ps << EOF
164 -19.1 New Caledonia
EOF
# Step-11. Add logo
gmt logo -R -J -Dx7.0/-3.5+o0.1i/0.1i+w2c -O -K >> $ps
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y4.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 11.0 Data source of geoid reference: EGM96 Earth Gravitational Model
EOF
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_VVT.ps -A1.0c -E720 -Tj -Z
