#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Yap and Palau trenches).
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_IO.ps

# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=0.3c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.7c \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=8p,Palatino-Roman,dimgray \
    
# Step-3. Select a color palette
gdalinfo geoid.egm96.grd -stats
# Minimum=-106.505, Maximum=86.417, Mean=-0.808, StdDev=29.198
gmt makecpt -Chawaii -T-107/87/1 > colors.cpt

# Step-4. Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 \
    -R20/120/-65/30 -JQ5.0i -Ccolors.cpt -P -K > $ps
# makecpt --help
    
# Step-5. Add basemap: grid, title, coastline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid regional model: Indian Ocean" \
    --MAP_TITLE_OFFSET=0.3c \
	-Bpx204f10a10 -Bpyg20f10a10 -Bsxg5 -Bsyg5 \
    -O -K >> $ps
    
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C3 -A6 -Wthinnest,dimgray -O -K >> $ps

# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=6p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx0.8c/10.3c+w0.3i+f2+l+o0.15i \
    -Lx11c/-1.3c+c50+w2000k+l"Cylindrical equidistant prj. Scale: km"+f \
    -UBL/-10p/-40p -O -K >> $ps
    
# Step-9. Add color legend
gmt psscale -Dg0.0/-65+w12.0c/0.4c+v+o0.3/0i+ml -R20/120/-65/30 -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Hawaii: perceptually uniform sequential colormap, by Fabio Crameri [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Step-11. Add logo
gmt logo -Dx5.2/-2.2+o0.1i/0.1i+w2c -O >> $ps

# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_IO.ps -A1.0c -E720 -Tj -Z
