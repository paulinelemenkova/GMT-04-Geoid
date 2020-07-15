#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Indian Ocean, Sunda Trench)
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

#grdcut geoid.egm96.grd -R90/130/-20/10 -Ggeoid_ST96.grd
grdconvert s45e90/ geoid_ST.grd
gdalinfo geoid_ST.grd -stats
# Minimum=-64.559, Maximum=80.817
grdconvert n00e90/ geoid_ST1.grd
gdalinfo geoid_ST1.grd -stats
# Minimum=-66.313, Maximum=76.565


# Generate a color palette table from grid
gmt makecpt -Chaxby -T-65/81/1 > colors.cpt
gmt makecpt -Chaxby -T-67/77/1 > colors1.cpt

# Generate a file
ps=Geoid_ST.ps
gmt grdimage geoid_ST.grd -Ccolors.cpt -R90/130/-20/10 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_ST1.grd -Ccolors1.cpt -R90/130/-20/10 -JM6i -P -I+a15+ne0.75 -Xc -O -K >> $ps
#gmt grdimage geoid_ST96.grd -Ccolors.cpt -R90/130/-20/10 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add shorelines
gmt grdcontour geoid_ST.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps
gmt grdcontour geoid_ST1.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -B+t"Geoid gravitational regional model: Sumatra and Java region" \
    -Lx12.7c/-1.3c+c318/-57+w800k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-40p -O -K >> $ps
    
gmt psscale -Dg84.8/-20+w11.4c/0.4c+v+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Ba10f2+l"Color scale: haxby (B. Haxby's color scheme for geoid & gravity [C=RGB] -65/77)" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thinner,red -Wthinner -Df -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
112 1 Kalimantan
109 -7.8 Java
119 -2 Sulavesi
104 0.5 Singapore
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-46 -Gwhite@30 >> $ps << EOF
101.5 -0.5 Sumatra
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
121 9 PHILIPPINES
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
98 7.5 THAILAND
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica-Oblique,yellow+jLB >> $ps << EOF
94 -9.5 I N D I A N
94 -11.0 O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
106 7.0 South China
108 6.0 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
120.5 4 Celebes Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
108 -4.8 Java Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
124 -4.8 Banda
124.5 -5.8 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
126.0 -11 Timor
126.4 -12 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
127 8 Philippine
127.8 7.1 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,red+jLB -Gwhite@30 >> $ps << EOF
90.5 0.2 Equator
EOF

# Add GMT logo
gmt logo -Dx6.2/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.5 10.0 World geoid image EGM2008 vertical datum 2.5 min resolution
#1.5 10.0 World geoid image EGM96 vertical datum 15 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_ST.ps -A0.5c -E720 -Tj -Z
