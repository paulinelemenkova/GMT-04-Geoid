#!/bin/sh
# Purpose: Geoid model map with coastline and grid crosses
# Equidistant conic projection (here: Aleutian Trench). Small inserted World map: Eckert VI projection.
# GMT modules: gmtset, grd2cpt, grdimage, pscoast, grdcontour, psbasemap, psscale, psimage, logo, pstext, psconvert
# Step-1. Generate a file
ps=Geoid_AT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_TITLE_OFFSET=1c \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinnest \
    MAP_GRID_CROSS_SIZE_PRIMARY=0.1i \
    FONT_TITLE=14p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Palatino-Roman,dimgray \
    FONT_LABEL=7p,Palatino-Roman,dimgray \
# Step-3. Generate a color palette table from grid
gmt grd2cpt geoid.egm96.grd -Crainbow > geoid.cpt
# Step-4. Generate geoid image with shading
gmt grdimage geoid.egm96.grd -I+a45+nt1 -R154/220/40/65 -JD186/52/45/59/6i -Cgeoid.cpt -P -K > $ps
# Step-5. Add basemap: grid, title, costline
gmt pscoast -R -J -P \
	-V -W0.25p \
    -Df -B+t"Geoid gravitational regional model: Aleutian Trench area" \
	-Bxg3f4a8 -Byg3f2a4 \
    -O -K >> $ps
# Step-6. Add geoid contour
gmt grdcontour geoid.egm96.grd -R -J -C2 -A5 -Wthinnest,dimgray -O -K >> $ps
# Step-7. Add scale
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    --MAP_TITLE_OFFSET=0.3c \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx13c/-2.4c+c50+w1500k+l"Equidistant conic projection. Scale, km"+f \
    -UBL/-15p/-67p -O -K >> $ps
# Step-8. Add magnetic rose
gmt psbasemap -R -J \
    --FONT=6p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=5p \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_TICK_PEN_PRIMARY=thinnest,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Tmg136/56+w3.4c+d-14.5+t45/10/5+ithin,blue+p0.1p,red+l+jCM \
    -O -K >> $ps
# Step-9. Add color legend
gmt psscale -R -J -Cgeoid.cpt\
    -DjBC+o0.8c/-1.8c+w12c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Gravitation modelling color scale" \
    -I0.2 -By+lmGal -O -K >> $ps
# Step-10. Insert map (global geoid)
gmt psimage -R -J Geoid_World.jpg -DjTR+w4.3c+o-6.3c/0c -O -K >> $ps
# Step-11. Add logo
gmt logo -R -J -Dx6.5/-3.2+o0.1i/0.1i+w2c -O -K >> $ps
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y0c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 14.5 World Geoid Image version 9.2, 2 min resolution
EOF
# Step-13. Add text
gmt pstext -R -J -X2.5c -Y-7.4c -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jCB >> $ps << END
10.0 0.0 Standard paralles at 52\232 and 59\232 N
END
# Step-14. Add text
gmt pstext -R -J -N -X-4.0c -Y2.5c -O \
    -F+f7p,Palatino-Roman,dimgray+jCB >> $ps << END
0.0 15.0 Magnetic rose
END
# Step-15. Convert to image file using GhostScript
gmt psconvert Geoid_AT.ps -A0.2c -E720 -Tj -Z
#-Tdg144/57.5+w0.5c+f2+l \
#-Dg218/43+w4.7i/0.15i+h+o1.0/0i+ml \
