#!/bin/sh
# Purpose: Geoid model map (here: Ross Sea)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=0.7c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# -R160/220/-81/-60 -Js190/-90/5.5i/-60

# 'cent2_geoid/' - папка с ESRI GRDI файлами
grdconvert s90e135/ EGM2008rs1.grd
grdconvert s90w180/ EGM2008rs2.grd
#grdconvert s90e90/ EGM2008rs3.grd
grdconvert s90w135/ EGM2008rs3.grd

gdalinfo EGM2008rs1.grd -stats
# Minimum=-62.343, Maximum=9.276
gdalinfo EGM2008rs2.grd -stats
# Minimum=-66.517, Maximum=3.503
gdalinfo EGM2008rs3.grd -stats
# Minimum=-50.151, Maximum=13.888

# Make color palette
# gmt makecpt -Chaxby.cpt -V -T-67/10/1 > colors.cpt
# gmt makecpt -Chaxby.cpt -V -T-100/100/10 > colors.cpt
gmt makecpt -Chaxby.cpt -V -T-70/14 > colors.cpt

# Generate a file
ps=Geoid_RS.ps
gmt grdimage EGM2008rs1.grd -Ccolors.cpt -R160/220/-81/-60 -JM5.5i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage EGM2008rs2.grd -Ccolors.cpt -R160/220/-81/-60 -JM5.5i -P -I+a15+ne0.75 -Xc -O -K >> $ps
gmt grdimage EGM2008rs3.grd -Ccolors.cpt -R160/220/-81/-60 -JM5.5i -P -I+a15+ne0.75 -Xc -O -K >> $ps

gmt grdcontour EGM2008rs1.grd -R -J -C1 -A2 -Wthinner,white -O -K >> $ps
gmt grdcontour EGM2008rs2.grd -R -J -C1 -A2 -Wthinner,white -O -K >> $ps
gmt grdcontour EGM2008rs3.grd -R -J -C1 -A2 -Wthinner,white -O -K >> $ps

# Add shorelines
gmt grdcontour rs_relief.nc -R -J -C2000 -Wthin -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a10 -Bpyg10f2.5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --FONT_LABEL=7p,Helvetica,black \
    -B+t"Geoid geopotential model: Ross Sea" \
    -Lx10.7c/-2.6c+c318/-57+w1000k+l"Mercator projection"+f \
    -UBL/1.0c/-75p -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,white+jLB >> $ps << EOF
185.5 -67.0 R O S S
186.5 -68.5 S E A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,black+jLB >> $ps << EOF
175.5 -76.0 Ross
176.5 -77.2 Ice
177.5 -78.4 Shelf
EOF

gmt psscale -R -J -Ccolors.cpt \
    -DjBC+o0.0c/-1.7c+w14c/0.5c+h \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Bg10f5a10++l"Color scale 'haxby': B. Haxby's color scheme for geoid & gravity [R=-70/14/1, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx5.7/-3.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y7.3c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.7 14.7 Global geoid image EGM2008-WGS84 2,5 minute resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_RS.ps -A1.0c -E720 -Tj -Z

#gmt grdimage EGM2008rs1.grd -Ccolors.cpt -R160/-81/220/-60r -JA190/-70/5.5i -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage EGM2008rs2.grd -Ccolors.cpt -R160/-81/220/-60r -JA190/-70/5.5i -P -I+a15+ne0.75 -Xc -O -K >> $ps
#gmt grdimage EGM2008rs3.grd -Ccolors.cpt -R160/-81/220/-60r -JA190/-70/5.5i -P -I+a15+ne0.75 -Xc -O -K >> $ps
