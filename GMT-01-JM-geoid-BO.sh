#!/bin/sh
# Purpose: geoid of Venezuela
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert
# http://soliton.vm.bytemark.co.uk/pub/cpt-city/kst/tn/33_blue_red.png.index.html

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

gmt grdconvert s45w90/w001001.adf geoid_01.grd
gdalinfo geoid_01.grd -stats
# Minimum=-28.476, Maximum=50.095, Mean=7.756, StdDev=14.446


# Generate a color palette table from grid
# gmt makecpt --help
# gmt makecpt -C25_mac_style.cpt -T-55/25 > colors.cpt
gmt makecpt -Chx-120-120.cpt -T-10/51 > colors.cpt
#-Ic Reverse sense of color table spectrum
# haxby

# Generate a file
ps=Geoid_BO.ps
gmt grdimage geoid_01.grd -Ccolors.cpt -R290/302.5/-23/-9 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_01.grd -R -J -C1.0 -A2.0+f8p,0,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx4f2a2 -Bpyg4f2a2 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=16p,25,black \
    -B+t"Geoid model (EGM-2008) of Bolivia" -O -K >> $ps
    
# Add legend
gmt psscale -Dg290/-23.8+w16.0c/0.4c+h+o0.0/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=8p,25,black \
    -Bg2f0.2a4+l"Color scale 'hx-120-120': J.J. Green's variant on the gradient by W.F. Haxby [discrete, RGB, 32 segments]" \
    -I0.2 -By+lm -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.0c/-2.3c+c50+w200k+l"Mercator projection. Scale (km)"+f \
    -UBL/-5p/-65p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thickest,magenta -Wthick,darkslategray -Df -O -K >> $ps

# Texts
# Cities
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
296.92 -18.0 Santa Cruz de la Sierra
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
296.82 -17.8 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
291.94 -16.72 El Alto
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
291.84 -16.52 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
223.80 -16.5 La Paz
EOF
gmt psxy -R -J -Sc -W0.5p -Gred -O -K << EOF >> $ps
223.70 -16.5 0.25c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
294.0 -17.38 Cochabamba
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
293.83 -17.38 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
292.2 -17.80 Oruro
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
292.88 -17.96 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
294.85 -19.05 Sucre
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
294.75 -19.05 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
295.66 -21.32 Tarija
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
295.56 -21.32 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
293.5 -19.9 Potosí
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
294.25 -19.58 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
294.06 -17.65 Sacaba
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
293.96 -17.40 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
293.92 -18.0 Quillacollo
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
293.72 -17.4 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
296.85 -17.25 Montero
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
296.75 -17.34 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
295.20 -14.8 La Santísima
295.20 -15.1 Trinidad
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
295.10 -14.83 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
296.13 -21.90 Yacuíba
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
296.33 -22.02 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
296.94 -17.60 Warnes
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
296.84 -17.52 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
293.04 -11.40 Riberalta
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
293.94 -11.01 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
291.0 -16.95 Viacha
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
291.7 -16.65 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,white+jLB+a-0 >> $ps << EOF
294.68 -16.97 Villa Tunari
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
294.58 -16.97 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,0,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
292.6 -17.20 Tiquipaya
EOF
gmt psxy -R -J -Sc -W0.5p -Ggold -O -K << EOF >> $ps
293.79 -17.8 0.20c
EOF
# water
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,azure+jLB >> $ps << EOF
290.5 -15.55 Lake
290.5 -15.80 Titicaca
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,azure+jLB >> $ps << EOF
291.17 -16.23 Lago
291.17 -16.50 Huiñaymarca
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,azure+jLB >> $ps << EOF
292.92 -18.75 Lake
292.92 -19.0 Poopó
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,black+jLB >> $ps << EOF
292.0 -20.13 Salar
292.0 -20.38 de Uyuni
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,black+jLB >> $ps << EOF
291.88 -19.10 Salar
291.88 -19.40 de Coipasa
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,24,white+jLB >> $ps << EOF
292.60 -18.25 Uru Uru
292.60 -18.50 Lake
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,23,cadetblue2+jLB >> $ps << EOF
295.35 -13.60 Laguna
295.35 -13.88 San Luis
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,23,cadetblue2+jLB >> $ps << EOF
292.02 -13.96 Laguna
292.02 -14.23 Rogagua
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,23,cadetblue2+jLB >> $ps << EOF
294.06 -13.03 Laguna
294.06 -13.31 Rogaguado
EOF
# geography
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,3,white+jLB+a-60 >> $ps << EOF
294.0 -18.55 Cordillera Real
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,3,white+jLB+a-63 >> $ps << EOF
291.0 -19.0 Cordillera Occidental
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,3,white+jLB+a-60 >> $ps << EOF
293.1 -20.13 Altiplano
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,10,mintcream+jLB+a-345 >> $ps << EOF
298.5 -19.13 Gran Chaco
EOF
# countries
gmt pstext -R -J -N -O -K \
-F+jTL+f22p,25,darkmagenta+jLB >> $ps << EOF
294.0 -16.6 B  O  L  I  V  I  A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,firebrick4+jLB >> $ps << EOF
296.0 -11.0 B  R  A  Z  I  L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,black+jLB+a-270 -Gwhite@60 >> $ps << EOF
290.5 -15.0 P E R U
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,black+jLB -Gwhite@60 >> $ps << EOF
294.0 -22.85 A R G E N T I N A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,black+jLB -Gwhite@60 >> $ps << EOF
290.0 -21.8 C H I L E
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,firebrick4+jLB >> $ps << EOF
298.2 -21.5 P A R A G U A Y
EOF
# rivers -R290/302.5/-23/-9
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-298 >> $ps << EOF
293.1 -13.2 Beni
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-330 >> $ps << EOF
291.6 -13.2 Madidi
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,lightblue+jLB+a-0 >> $ps << EOF
292.1 -11.90 Madidi
292.0 -12.15 National
292.2 -12.40 Park
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-310 >> $ps << EOF
294.0 -15.1 Apere
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-340 >> $ps << EOF
293.3 -14.1 Yacuma
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-80 >> $ps << EOF
295.0 -15.1 Mamoré
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-45 >> $ps << EOF
296.5 -13.1 San Martín
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-60 >> $ps << EOF
298.2 -14.3 Paragúa
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,azure1+jLB+a-67 >> $ps << EOF
296.90 -15.0 Blanco
EOF

# Add GMT logo
gmt logo -Dx6.2/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X1.2c -Y10.8c -N -O \
    -F+f12p,25,black+jLB >> $ps << EOF
1.5 13.6 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_BO.ps -A1.0c -E720 -Tj -Z
