#!/bin/sh
# Purpose: geoid of Iran
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
gdalinfo geoid_IR.grd -stats
# Minimum=-106.909, Maximum=22.126
gdalinfo geoid_IQ.grd -stats
# Minimum=-43.581, Maximum=54.907


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Chaxby -T-100/50/1 > colors.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_IR.ps
gmt grdimage geoid_IR.grd -Chaxby -R43/65/24/40 -JM6.5i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_IQ.grd -Ccolors.cpt -R -J -P -I+a15+ne0.75 -Xc -O -K >> $ps

# Add shorelines
gmt grdcontour geoid_IR.grd -R -J -C1 -A1+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps
gmt grdcontour geoid_IQ.grd -R -J -C1 -A1+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg2f1a2 -Bpyg2f1a2 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=7p,25,black \
    --FONT_LABEL=8p,25,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational model of Iran" \
    -Lx14.0c/-2.5c+c318/-57+w300k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg43.0/22.5+w16.0c/0.15i+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=6p,Helvetica,black \
    -Bg10f1a10+l"Color scale: haxby for geoid & gravity [R=-107/23/1, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thicker,goldenrod1 -Wthinner -Df -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,26,blue+jLB >> $ps << EOF
50.0 38.5 Caspian Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB >> $ps << EOF
59.4 24.4 Gulf of Oman
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-53 >> $ps << EOF
50.0 28.5 P e r s i a n  G u l f
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-324 >> $ps << EOF
54.3 25.3 Strait of
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-80 >> $ps << EOF
56.7 26.0 Hormuz
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
51.2 35.2 Tehran
EOF
gmt psxy -R -J -Sg -W0.5p -Gyellow -O -K << EOF >> $ps
51.0 35.0 0.20c
EOF
#
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,25,white+jLB+a-47 >> $ps << EOF
48.3 34.5 Z a g r o s
51.3 31.7 M o u n t a i n s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,brown+jLB+a-20 >> $ps << EOF
49.5 36.8 E l b u r z
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB+a-30 >> $ps << EOF
57.0 37.5 K ö p e t  D a g
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,0,brown+jLB >> $ps << EOF
54.0 34.2 G r e a t
55.8 32.8 S a l t
57.4 31.2 D e s e r t
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,blue2+jLB+a-55 >> $ps << EOF
46.2 32.1 Tigris
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,blue2+jLB+a-15 >> $ps << EOF
45.0 30.8 Euphrates
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB >> $ps << EOF
59.0 26.4 M  a  k  r  a  n
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB >> $ps << EOF
53.8 34.6 Dasht-e Kavir
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB+a-60 >> $ps << EOF
58.2 30.8 Dasht-e Lut
EOF

# Add GMT logo
gmt logo -Dx7.0/-3.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.8c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
2.5 9.3 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_IR.ps -A0.5c -E720 -Tj -Z
