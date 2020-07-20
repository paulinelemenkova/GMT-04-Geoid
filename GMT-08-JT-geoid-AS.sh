#!/bin/sh
# Purpose: geoid raster map from the EGM2008 from 2.5 arc minute global data set: Arabian Sea
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-2. GMT set up
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
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# 120W 50E 65S 65N

# makecpt --help
# Select a color palette
gdalinfo as_geoid.nc -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chaxby -T-104/-2/1 > colors.cpt

grdcut EGM2008ME.grd -R47/77/0/31 -Gas_geoid.nc

# Generate a file
ps=Geoid_AS.ps
# Make raster image
# Generate geoid image with shading
#gmt grdimage geoid.egm96.grd -I+a45+nt1 \
 #   -R47/77/0/31 -JT62/15/6i -Ccolors.cpt -P -K > $ps
gmt grdimage EGM2008ME.grd -I+a45+nt1 \
    -R47/77/0/31 -JT62/15/6i -Ccolors.cpt -P -K > $ps
# makecpt --help

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg2.5 -Bsyg2.5 \
    --MAP_TITLE_OFFSET=1.1c \
    --FONT_TITLE=13p,Palatino-Roman,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -B+t"Geoid regional model: Arabian Sea region" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=9p,Helvetica,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx12.6c/14.0c+w0.3i+f2+l+o0.15i \
    -Lx12.2c/-2.8c+c50+w1000k+l"Transverse Mercator projection. Scale: km"+f \
    -UBL/-5p/-80p -O -K >> $ps
    
# Add color legend
gmt psscale -Dg47/-2.9+w15.0c/0.4c+h+o0.3/0i+ml -R47/77/0/31 -J -Ccolors.cpt \
    --FONT_LABEL=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    -Baf+l"Color scale: Haxby: Bill Haxby's color scheme for geoid heights, m [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thinner,red -Wthinner -Df -O -K >> $ps

# Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C6 -A12 -Wthinnest,dimgray -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,brown+jLB >> $ps << EOF
63.0 20.8 Oman
62.0 20.3 Abyssal Plain
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times−Bold,brown+jLB+a-290 >> $ps << EOF
60.2 17.0 Owen
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times−Bold,brown+jLB+a-300 >> $ps << EOF
60.9 18.8 Fracture
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times−Bold,brown+jLB+a-315 >> $ps << EOF
62.2 21.0 Zone
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,brown+jLB >> $ps << EOF
60.0 23.5 Gulf of
60.1 23.0 Oman
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-335 -Gwhite@40 >> $ps << EOF
48.2 12.5 Gulf of Aden
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-49 >> $ps << EOF
49.5 29.0 P e r s i a n  G u l f
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times−Bold,black+jLB+a-325 -Gwhite@40>> $ps << EOF
63.3 22.1 Murray Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
56.5 21.5 OMAN
62.5 27.0 P A K I S T A N
54.0 30.2 I R A N
74.0 22.0 I N D I A
49.0 22.0 SAUDI
49.0 21.3 ARABIA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,blue+jLB >> $ps << EOF
61.0 15.5 ARABIAN
62.2 14.0 SEA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-300 -Gwhite@50 >> $ps << EOF
48.0 6.0 S O M A L I
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,red+jLB+a-270 -Gwhite@60 >> $ps << EOF
74.0 2.0 M  a  l  d  i  v  e  s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@50 >> $ps << EOF
53.0 11.7 Socotra
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-333 -Gwhite@50 >> $ps << EOF
48.5 15.1 Y E M E N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-40 -Gwhite@60 >> $ps << EOF
58.2 7.5 C a r l s b e r g  R i d g e
EOF

# Add GMT logo
gmt logo -Dx6.2/-3.4+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f12p,Palatino-Roman,black+jLB >> $ps << EOF
1.5 15.3 World geoid image 2,5 minute resolution, EGM2008-WGS 84
0.8 14.6 Transverse Mercator prj. Central meridian: 62\232E Standard parallel: 15\232N
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert Geoid_AS.ps -A1.5c -E720 -Tj -Z
