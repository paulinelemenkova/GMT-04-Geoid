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

gdalinfo geoid.egm96.grd -stats
gmt grd2cpt geoid.egm96.grd -Cjet > geoid.cpt
# Generate geoid image with shading

ps=Geoid_Ker.ps
gmt grdimage geoid.egm96.grd -I+a45+nt1 -R40/110/-70/-20 -JQ7.5i -Cgeoid.cpt -P -K > $ps

# Add shorelines
gmt grdcontour geoid.egm96.grd -R -J -C2 -A4+f10p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg10f5a10 -Bpyg10f5a10 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_FRAME_AXES=wESN \
    --FONT_ANNOT_PRIMARY=10p,0,dimgray \
    --FONT_TITLE=13p,0,black \
    --FONT_LABEL=10p,0,black \
    -B+t"Geoid gravitational model EGM96 over East Antarctic, Kerguelen Plateau and SW Indian Ocean" \
    -Lx16.0c/-1.5c+c318/-57+w1000k+l"Cylindrical equidistant projection. Scale (km)"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Texts

# Add legend
gmt psscale -Dg33/-70+w13.4c/0.4c+v+ml+e -R -J -Cgeoid.cpt \
    --FONT_LABEL=10p,0,dimgray \
    --FONT_ANNOT_PRIMARY=10p,0,black \
    -Bg10f1a10+l"Color scale: jet [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx7.0/-2.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y12.5c -N -O \
    -F+f12p,0,black+jLB >> $ps << EOF
1.0 3.0 EGM96: 15 arc minute resolution grid based on the gravitational force of the Earth
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_Ker.ps -A1.6c -E720 -Tj -Z
