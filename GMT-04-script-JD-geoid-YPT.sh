#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Yap and Palau trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_YPT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=0.3c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.7c \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
# Step-3. Generate a color palette table from grid
gmt grd2cpt geoid.egm96.grd -Cjet -V -T-0/100 > geoid.cpt
# Step-4. Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R116/145/-6/20 -JM16c -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid regional model: Philippine Sea, Philippine archipelago, Yap and Palau trenches area" \
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
    --FONT_ANNOT_PRIMARY=8p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@30 >> $ps << EOF
116.5 1.5 KALIMANTAN
119 -2.0 SULAWESI
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
121 12.0 PHILIPPINES
137 -4.0 PAPUA NEW GUINEA
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
128.5 13.5 PHILIPPINE SEA
136 18.5 P A C I F I C  O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
120.5 3.5 CELEBES SEA
118.5 8 SULU SEA
117 17 SOUTH
117 16.4 CHINA
117 15.8 SEA
127 -5 BANDA SEA
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jLB+a-308 -Gwhite@30 >> $ps << EOF
137.7 6.8 Yap Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jLB+a-310 -Gwhite@30 >> $ps << EOF
133.5 4.5 Palau Trench
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,Palatino-Roman,red+jBL+a-70 -Gwhite@30 >> $ps << EOF
127 13.0 Philippine Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jBL+a-350 -Gwhite@30 >> $ps << EOF
141 9.7 Mariana Trench
EOF
# Step-11. Add logo
gmt logo -R -J -Dx7.0/-3.5+o0.1i/0.1i+w2c -O >> $ps
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_YPT.ps -A1.0c -E720 -Tj -Z
