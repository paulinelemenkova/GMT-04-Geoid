#!/bin/sh
# Purpose: geoid of Rwanda
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
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

gmt grdconvert s45e00/w001001.adf geoid_TZ.grd
gdalinfo geoid_TZ.grd -stats
# Minimum=-43.794, Maximum=47.399


# Generate a color palette table from grid
# gmt makecpt --help
#gmt makecpt -Chaxby -T-44/55/1 > colors.cpt
gmt makecpt -Cwysiwyg -T-20/0/1 > colors.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_RW.ps
gmt grdimage geoid_TZ.grd -Cwysiwyg -R28.5/31/-3/-1 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_TZ.grd -R -J -C0.25 -A1+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpxg1f0.5a0.25 -Bpyg1f0.5a0.25 -Bsxg1 -Bsyg1 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=13p,13,black \
    -B+t"Geoid gravitational model of Rwanda" -O -K >> $ps
    
# Add legend
gmt psscale -Dg28.5/-3.2+w16.5c/0.15i+h+o0.3/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=8p,Helvetica,black \
    -Bg2f0.2a2+l"Color scale wysiwyg: 20 well-separated RGB colors [C=RGB, -T0/40/1]" \
    -I0.2 -By+lm -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.5c/-2.4c+c50+w50k+l"Mercator projection. Scale (km)"+f \
    -UBL/-10p/-70p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,white -Wthinner -Df -O -K >> $ps

# Texts
# Lakes
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
29.2 -1.95 Lake
29.2 -2.05 Kivu
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
30.32 -2.32 Lake
30.32 -2.37 Rweru
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
30.75 -1.81 Lake
30.75 -1.86 Ihema
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
30.31 -2.05 Lake
30.31 -2.10 Mugesera
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
30.4 -1.85 Lake Muhazi
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
29.78 -1.45 Lake Burera
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
29.74 -1.51 Lake Ruhondo
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue2+jLB >> $ps << EOF
30.0 -2.25 Lake
29.9 -2.3 Cyohoha South
EOF

# countries
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.4 -1.1 U  G  A  N  D  A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.4 -2.9 B U R U N D I
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.55 -2.65 T A N Z A N I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,0,black+jLB -Gwhite@60 >> $ps << EOF
28.6 -1.6 C O N G O
28.6 -1.7 (D.R.C.)
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,26,black+jLB >> $ps << EOF
29.6 -2.2 R    W    A    N    D    A
EOF
# Cities
gmt pstext -R -J -N -O -K \
-F+f13p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.08 -1.90 Kigali
EOF
gmt psxy -R -J -Ss -W0.5p -Gred -O -K << EOF >> $ps
30.06 -1.94 0.40c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.00 -1.5 Byumba
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.06 -1.57 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.70 -2.30 Nyanza
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
29.73 -2.35 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.44 -1.97 Rwamagana
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.43 -1.95 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.70 -2.04 Muhanga
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
29.75 -2.08 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.36 -2.03 Kibuye
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
29.35 -2.06 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
29.70 -2.55 Butare
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
29.75 -2.6 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
28.90 -2.46 Cyangugu
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
28.89 -2.48 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.56 -2.10 Kibungo
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.54 -2.15 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@60 >> $ps << EOF
30.33 -1.31 Nyagatare
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.32 -1.29 0.20c
EOF

# Add GMT logo
gmt logo -Dx7.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y8.0c -N -O \
    -F+f10p,13,black+jLB >> $ps << EOF
3.0 9.0 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_RW.ps -A0.5c -E720 -Tj -Z
