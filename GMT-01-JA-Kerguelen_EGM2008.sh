#!/bin/sh
# Purpose: sediment thickness (here: Kergelen)
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

gmt grdconvert s45e45/w001001.adf geoid_Kerg1.grd
gmt grdconvert s45e90/w001001.adf geoid_Kerg2.grd
gmt grdconvert s90e45/w001001.adf geoid_Kerg3.grd
gmt grdconvert s90e90/w001001.adf geoid_Kerg4.grd

gdalinfo geoid_Kerg2.grd -stats
# actual_range={-30.15500068664551,51.99800109863281}
gdalinfo geoid_Kerg1.grd -stats
# actual_range={-102.8290023803711,46.45000076293945}

# Make color palette
gmt makecpt -Cjet.cpt -V -T-50/60 > myocean.cpt
#makecpt --help

exec bash

ps=Geoid_Kgl.ps
gmt grdimage geoid_Kerg1.grd -Cmyocean.cpt -R-25/-65/101/-10r -JA55/-50/7.5i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_Kerg2.grd -Cmyocean.cpt -R -J -P -Xc -O -K >> $ps
gmt grdimage geoid_Kerg3.grd -Cmyocean.cpt -R -J -P -Xc -O -K >> $ps
gmt grdimage geoid_Kerg4.grd -Cmyocean.cpt -R -J -P -Xc -O -K >> $ps

# Add shorelines
gmt grdcontour geoid_Kerg1.grd -R -J -C2 -A10+f10p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_Kerg2.grd -R -J -C2 -A10+f10p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_Kerg3.grd -R -J -C2 -A10+f10p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_Kerg4.grd -R -J -C2 -A10+f10p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wESN \
    -Bpxg10f5a20 -Bpyg10f5a15 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.7c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_FRAME_AXES=wESN \
    --FONT_ANNOT_PRIMARY=10p,0,dimgray \
    --FONT_TITLE=13p,0,black \
    --FONT_LABEL=10p,0,black \
    -B+t"Geoid gravitational model EGM-2008 over East Antarctic, Kerguelen Plateau and SW Indian Ocean" \
    -Lx16.5c/-1.7c+c318/-57+w2000k+l"Scale (km) at 55\232E 50\232S"+f \
    -UBL/-5p/-50p -O -K >> $ps

# Texts

# Add legend
gmt psscale -Dg-30/-58+w15.4c/0.4c+v+ml+e -R -J -Cgeoid.cpt \
    --FONT_LABEL=11p,0,dimgray \
    --FONT_ANNOT_PRIMARY=11p,0,black \
    -Bg10f1a10+l"Color scale: jet, dark to light blue, white, yellow and red [C=RGB]" \
    -I0.2 -By+l"m" -O -K >> $ps

# Add GMT logo
gmt logo -Dx5.5/-2.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y12.5c -N -O \
    -F+f12p,0,black+jLB >> $ps << EOF
1.0 7.0 EGM96: 15 arc minute resolution grid based on the gravitational force of the Earth
1.0 6.2 Lambert Azimuthal Equal-Area projection. Central meridian 55\232E, standard parallel 50\232S
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_Ker.ps -A1.6c -E720 -Tj -Z
