#!/bin/sh
# Purpose: geoid grid raster map from the EGM96 global data set (here: Caribbean Sea)
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
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# makecpt --help
# Select a color palette
gdalinfo geoid.egm96.grd -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chaxby -T-107/87/1 > colors.cpt

# Generate a file
ps=Geoid_CS.ps
# Make raster image
gmt grdimage geoid.egm96.grd -Ccolors.cpt -R270/305/7/24 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f2.5a5 -Bpyg10f2.5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Geoid regional model: Caribbean Sea" -O -K >> $ps
    
# Add shorelines
gmt grdcontour geoid.egm96.grd -R270/305/7/24 -JM6i -C1 -A5 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx13.8c/1.0c+w0.2i+f2+l+o0.1c \
    -Lx12.7c/-1.3c+c50+w700k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Add legend
gmt psscale -Dg265.5/7+w7.7c/0.4c+v+o0.3/0i+ml -R270/305/7/24 -J -Ccolors.cpt \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale: Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-65 >> $ps << EOF
298.0 18.0 L e s s e r
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-86 >> $ps << EOF
299.3 15.1 Antilles
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,red+jLB >> $ps << EOF
282.5 15.1 C A R I B B E A N  S E A
293 22.0 A T L A N T I C   O C E A N
270.2 9.0 PACIFIC
270.2 8.2.0 OCEAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-30 >> $ps << EOF
281 22 Cuba
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB >> $ps << EOF
282 18.7 Jamaica
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB >> $ps << EOF
287.5 17.5 Hispaniola
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB >> $ps << EOF
293 17.5 Puerto Rico
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-20 >> $ps << EOF
279.0 23.5 G    r    e    a    t    e    r       A    n    t    i    l    l    e    s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-27 >> $ps << EOF
286.0 23.5 B a h a m a s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB+a-350 >> $ps << EOF
276 17.7 Cayman Trough
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB >> $ps << EOF
293 20 Puerto
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB+a-8 >> $ps << EOF
296 19.9 Rico
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB+a-25 >> $ps << EOF
298 19.4 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,blue+jLB >> $ps << EOF
282 13 Colombia
282 12 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,blue+jLB >> $ps << EOF
292.5 15.1 Venezuela
292.5 14.1 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,blue+jLB >> $ps << EOF
275.5 20.6 Yucatan
275.5 19.6 Basin
EOF

# Add GMT logo
gmt logo -Dx6.2/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
4.2 4.2 World geoid image version 9.2 EGM96
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_CS.ps -A0.5c -E720 -Tj -Z
