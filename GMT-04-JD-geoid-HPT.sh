#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Hikurangi, Puysegur and Hjort trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_HPT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=1.5c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinner \
    MAP_GRID_PEN_PRIMARY=thinner,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Helvetica,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
# Step-3. Generate a color palette table from grid
#gmt grd2cpt geoid.egm96.grd -Chaxby -V -T-100+100 > geoid.cpt
gmt grd2cpt geoid.egm96.grd -Chaxby > geoid.cpt
# Step-4. Generate geoid image with shading -R145/186/-62/-30 -JM16c
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R145/-62/186/-30r -JA165/-45/16c -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, coastline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid model: New Zealand, Hikurangi, Puysegur and Hjort trenches" \
    --FONT_TITLE=15p,Helvetica,black \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=10p,Helvetica,black \
	-Bxg10f5a5 -Byg5f2.5a5 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C1 -A2 -Wthinnest,dimgray -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.0c/-2.7c+w12c/0.5c+h\
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Ba20f+l"Gravitation modelling color scale. Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -UBL/2p/-98p -O -K >> $ps

# texts
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,black+jLB -Gwhite@20 >> $ps << EOF
176.2 -36.3 North
176.2 -37.0 Island
171.7 -45 South
171.7 -45.7 Island
159.3 -55 Macquarie Island
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
159 -55 0.2c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,black+jLB+a-310 -Gwhite@30 >> $ps << EOF
161.2 -53 Macquarie Arc
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,black+jLB -Gwhite@20 >> $ps << EOF
170 -50 CAMPBELL
170 -50.7 PLATEAU
175 -43.4 CHATHAM RISE
167 -39 CHALLENGER
167 -39.7 PLATEAU
161 -57 Hjort
161 -57.7 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f13p,Helvetica−Bold,white+jLB >> $ps << EOF
153.5 -38.5 T A S M A N  S E A
178 -52 P A C I F I C
178 -53 O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB+a-299 -Gwhite@30>> $ps << EOF
182 -36.2 Kermadec Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB+a-304 -Gwhite@30>> $ps << EOF
177.5 -42.0 Hikurangi Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB+a-308 -Gwhite@30>> $ps << EOF
158.5 -53.0 P u y s e g u r  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB+a-110 -Gwhite@30>> $ps << EOF
159 -56.0 Hjort
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB+a-56 -Gwhite@30>> $ps << EOF
158.2 -58.0 Trench
EOF
# Step-11. Add logo
gmt logo -Dx6.5/-4.2+o0.1i/0.1i+w2c -O -K >> $ps
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y11.9c -N -O \
    -F+f12p,Helvetica,black+jLB >> $ps << EOF
2.0 11.7 Data source of geoid reference: EGM96 Earth Gravitational Model
2.0 11.2 Lambert Azimuthal Equal-Area projection. Center lon/lat: 165\232W/45\232S
EOF
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_HPT.ps -A1.6c -E720 -Tj -Z
