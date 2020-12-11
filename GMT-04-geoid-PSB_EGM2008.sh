#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Philippine Sea basin)
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
    FONT_TITLE=12p,Helvetica,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

#grdcut geoid.egm96.grd -R90/130/-20/10 -Ggeoid_ST96.grd
gmt grdconvert n00e90/w001001.adf geoid_PSB1.grd
gdalinfo geoid_PSB1.grd -stats
# Minimum=-66.313, Maximum=76.565
gmt grdconvert n00e135/w001001.adf geoid_PSB2.grd
gdalinfo geoid_PSB2.grd -stats
# Minimum=-15.333, Maximum=72.740


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Cseis -T-67/76/1 -Ic > colors.cpt
gmt makecpt -Cseis -T-16/73/1 -Ic > colors1.cpt
# haxby

# Generate a file
ps=Geoid_PSB.ps
gmt grdimage geoid_PSB1.grd -Ccolors1.cpt -R120/152/4/35 -JM16c -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_PSB2.grd -Ccolors1.cpt -R120/152/4/35 -JM16c -P -I+a15+ne0.75 -Xc -O -K >> $ps
#gmt grdimage geoid_PSB2.grd -Ccolors1.cpt -R120/152/4/35 -JPoly/6i -P -I+a15+ne0.75 -Xc -O -K >> $ps

# Add shorelines
gmt grdcontour geoid_PSB1.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps
gmt grdcontour geoid_PSB2.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    --MAP_FRAME_AXES=WEsN \
    -B+t"Geoid gravitational regional model: Philippine Sea basin" \
    -Lx13.0c/-2.2c+c318/-57+w700k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-65p -O -K >> $ps
    
gmt psscale -Dg120.0/1.9+w15.0c/0.4c+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Ba10f2+l"Color scale: seis (R-O-Y-G-B seismic tomography colors [C=RGB] -65/77)" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thinner,red -Wthinner -Df -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-2.9+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y10.8c -N -O \
    -F+f10p,Helvetica,black+jLB >> $ps << EOF
2.2 10.0 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_PSB.ps -A0.5c -E720 -Tj -Z
