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

# 'cent2_geoid/' - папка с ESRI GRDI файлами
gmt grdconvert n00e00/w001001.adf EGM2008bg1.grd

# makecpt --help
# Select a color palette
#gdalinfo geoid.egm96.grd -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
#gmt makecpt -Chaxby -T0/87/1 > colors.cpt

# Generate a file
ps=Geoid_BG.ps
# Make raster image
gmt grdimage EGM2008bg1.grd -Chaxby -R22.0/29.0/41.0/44.5 -JM6.5i -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage geoid.egm96.grd -Chaxby -R22.0/29.0/41.0/44.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx4f0.5a1 -Bpyg4f0.5a1 -Bsxg2 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --MAP_FRAME_AXES=wESN \
    --FONT_TITLE=12p,Helvetica,black \
    -B+t"Geoid regional model of Bulgaria" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=9p,Helvetica,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Lx13.0c/-1.3c+c50+w150k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Add coastlines
gmt pscoast -R -J -P -Na -W0.6p -Df -O -K >> $ps
    
# Add isolines
gmt grdcontour EGM2008bg1.grd -R -J -C0.5 -A1 -W0.2p -O -K >> $ps

# Add legend
gmt psscale -Dg21.2/41.0+w11.0c/0.4c+v+o0.3/0i+ml+e -R -J -Chaxby \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale: Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.0c -N -O \
    -F+f10p,Helvetica,black+jLB >> $ps << EOF
3.0 9.0 Dataset: World geoid image EGM-2008 (2.5 min resolution)
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_BG.ps -A0.5c -E720 -Tj -Z
