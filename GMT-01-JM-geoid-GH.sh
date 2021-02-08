#!/bin/sh
# Purpose: geoid of Ghana
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

gmt grdconvert n00e00/w001001.adf geoid_ET.grd
gmt grdconvert n00w45/w001001.adf geoid_GH.grd
gdalinfo geoid_GH.grd -stats
# Minimum=-32, Maximum=65


# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Cwysiwyg -T10/30/0.5 > colors.cpt
#-Ic Reverse sense of color table
# haxby

# Generate a file
ps=Geoid_GH.ps
gmt grdimage geoid_GH.grd -Ccolors.cpt -R-4/2/4/12 -JM5.0i -P -Xc -K > $ps
gmt grdimage geoid_ET.grd -Ccolors.cpt -R-4/2/4/12 -JM5.0i -P -Xc -O -K >> $ps
#-I+a15+ne0.75

# Add shorelines
gmt grdcontour geoid_ET.grd -R -J -C0.25 -A0.5+f9p,25,black -Wthinner,dimgray -O -K >> $ps
gmt grdcontour geoid_GH.grd -R -J -C0.25 -A0.5+f9p,25,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpxg2f1a0.5 -Bpyg2f1a1 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --MAP_ANNOT_OFFSET=0.1c \
    --FONT_TITLE=12p,25,black \
    --FONT_ANNOT_PRIMARY=7p,25,black \
    --FONT_LABEL=8p,25,black \
    -B+t"Geoid gravitational model of Ghana" \
    -Lx11.0c/-2.4c+c318/-57+w100k+l"Mercator projection. Scale: km"+f \
    -UBL/0p/-70p -O -K >> $ps
    
# Add legend
gmt psscale -Dg-4/3.4+w12.0c/0.15i+h+o0.3/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg2f0.2a2+l"Color scale: 'wysiwyg' 20 well-separated RGB colors [T10/30/0.5, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,white -Wthinner -Df -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,royalblue4+jLB >> $ps << EOF
0.5 4.4 Gulf of Guinea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,royalblue4+jLB >> $ps << EOF
-3.5 4.5 Atlantic Ocean
EOF
# COUNTRIES
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,25,white+jLB >> $ps << EOF
-1.8 8.2 G   H   A   N   A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB >> $ps << EOF
0.7 8.5 T O G O
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,white+jLB >> $ps << EOF
-3.6 8.9 IVORY
-3.6 8.5 COAST
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB >> $ps << EOF
1.3 10.5 BENIN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,white+jLB >> $ps << EOF
-3.5 11.5 B  U  R  K  I  N  A      F  A  S  O
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB+a-280 >> $ps << EOF
0.2 6.7 Lake Volta
EOF
# Cities
gmt pstext -R -J -N -O -K \
-F+f11p,13,black+jLB >> $ps << EOF
-0.2 5.7 Accra
EOF
gmt psxy -R -J -Ss -W0.5p -Gwhite -O -K << EOF >> $ps
-0.1 5.6 0.30c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB >> $ps << EOF
-1.0 10.6 Bolgatanga
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.5 10.5 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB >> $ps << EOF
-1.0 5.2 Cape Coast
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.1 5.2 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB >> $ps << EOF
-1.1 5.0 Elmina
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.2 5.1 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-0.1 6.0 Koforidua
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.2 6.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.3 6.4 Kumasi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.4 6.4 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.3 6.1 Obuasi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.4 6.1 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB >> $ps << EOF
-2.0 4.8 Sekondi-
-2.0 4.6 Takoradi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.5 5.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.0 9.3 Tamale
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.5 9.2 0.20c
EOF

# Add GMT logo
gmt logo -Dx5.0/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y11.1c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
0.5 10.3 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_GH.ps -A0.5c -E720 -Tj -Z
