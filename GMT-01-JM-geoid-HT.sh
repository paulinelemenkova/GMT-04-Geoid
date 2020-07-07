#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Aegean Sea, Hellenic Trench)
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

#grdcut GEBCO_2019.nc -R19/37/30.5/41.5 -Ght_relief.nc # big s
#grdcut GEBCO_2019.nc -R19/31/32/39 -Ght_relief.nc
#grdcut ETOPO1_Ice_g_gmt4.grd -R19/31/32/39 -Ght_relief.nc

# makecpt --help
# Select a color palette
gdalinfo geoid.egm96.grd -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chaxby -T-30/87/1 > colors.cpt

# Generate a file
ps=Geoid_HT.ps
# Make raster image
gmt grdimage geoid.egm96.grd -Ccolors.cpt -R19/37/30.5/41.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx4f1a1 -Bpyg4f1a1 -Bsxg2 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Geoid regional model: the Aegean Sea region" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Lx13.0c/-1.3c+c50+w400k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Add coastlines
gmt pscoast -R -J -P -Na -W0.6p -Df -O -K >> $ps
    
# Add isolines
gmt grdcontour geoid.egm96.grd -R -J -C1 -A5 -W0.2p -O -K >> $ps

# Add legend
gmt psscale -Dg16.4/30.5+w11.4c/0.4c+v+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale: Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
4.0 9.9 World geoid image version 9.2 EGM96
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_HT.ps -A0.5c -E720 -Tj -Z
