#!/bin/sh
# Purpose: sediment thickness (here: North Sea, Atlantic Ocean)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, pscoast, pstext, gmtlogo, psconvert

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

# 'cent2_geoid/' - папка с ESRI GRDI файлами
grdconvert n45w45/ EGM2008NS1.grd
grdconvert n45e00/ EGM2008NS2.grd

grdcut EGM2008NS1.grd -R-7/15/50/63 -GEGM2008NS1ar.grd
grdcut EGM2008NS2.grd -R-7/15/50/63 -GEGM2008NS2ar.grd
gdalinfo EGM2008NS1.grd -stats
# Minimum=14.899, Maximum=68.183
gdalinfo EGM2008NS2.grd -stats
# Minimum=-3.257, Maximum=55.067
gdalinfo EGM2008NS1ar.grd -stats
# Minimum=45.034, Maximum=58.021
gdalinfo EGM2008NS2ar.grd -stats
#Minimum=28.801, Maximum=50.264

# Select a color palette
gmt makecpt -Chaxby.cpt -V -T28/58/1 > colors.cpt

# Generate a file
ps=Geoid_NS.ps

# Make raster image
gmt grdimage EGM2008NS1.grd -I+a45+nt1 -R-7/15/50/63 -JM5.5i -Ccolors.cpt -P -K > $ps
gmt grdimage EGM2008NS2.grd -I+a45+nt1 -R-7/15/50/63 -JM5.5i -Ccolors.cpt -P -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_TITLE_OFFSET=0.7c \
    --MAP_FRAME_AXES=WESN \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -Bpxg4f2a4 -Bpyg8f4a2 -Bsxg2 -Bsyg2 \
    -B+t"Geoid regional model: North Sea, Atlantic Ocean" -O -K >> $ps
    
# Add isolines
gmt grdcontour EGM2008NS1.grd -R -J -C1 -A1 -Wthin,dimgray -O -K >> $ps
gmt grdcontour EGM2008NS2.grd -R -J -C1 -A1 -Wthin,dimgray -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinner,blue -Na -N1/thin,red -Wthin -Df -O -K >> $ps

# Add scale
gmt psbasemap -R -J \
    --MAP_TITLE_OFFSET=0.1c \
    --FONT_LABEL=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    -Lx12.0c/-2.6c+c50+w500k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-75p -O -K >> $ps

# Add legend
gmt psscale -Dg-7/48.5+w14.0c/0.4c+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Bg5f1a5+l"Color scale: Haxby: Bill Haxby color scheme for geoid heights, m [C=RGB], actual range 28/58)" \
    -I0.2 -By+lmGal -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,brown+jLB -Gwhite@40 >> $ps << EOF
6.1 50.9 Luxemburg
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,brown+jLB -Gwhite@40 >> $ps << EOF
8.2 56.2 DENMARK
6.5 61 NORWAY
-3.5 55 UNITED
-3.5 52.5 K I N G D O M
3.3 50.7 BELGIUM
1.8 50.1 FRANCE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,brown+jLB+a-355 -Gwhite@40 >> $ps << EOF
9.5 51 GERMANY
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,brown+jLB+a-315 -Gwhite@40 >> $ps << EOF
4.5 51.5 NETHERLANDS
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,brown+jLB+a-355 -Gwhite@40 >> $ps << EOF
12.1 59 SWEDEN
EOF

# Add GMT logo
gmt logo -Dx6.0/-3.1+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.0c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.7 16.1 World geoid image 2,5 minute resolution, EGM2008-WGS 84
#1.7 13.0 Mercator zone 31, central meridian 4\232E
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_NS.ps -A0.8c -E720 -Tj -Z
