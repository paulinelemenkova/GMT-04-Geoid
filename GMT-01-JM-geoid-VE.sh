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

gmt grdconvert n00w90/w001001.adf geoid_02.grd
gdalinfo geoid_02.grd -stats
# Minimum=-70.856, Maximum=32.958, Mean=-24.768, StdDev=19.081


# Generate a color palette table from grid
# gmt makecpt --help
# gmt makecpt -C25_mac_style.cpt -T-55/25 > colors.cpt
gmt makecpt -C33_blue_red.cpt -T-55/25 > colors.cpt
#-Ic Reverse sense of color table spectrum
# haxby

# Generate a file
ps=Geoid_VE.ps
gmt grdimage geoid_02.grd -Ccolors.cpt -R286/300.5/0/12.5 -JM6.5i -P -Xc -I+a15+ne0.75 -K > $ps

# Add shorelines
gmt grdcontour geoid_02.grd -R -J -C1.0 -A2.0+f8p,0,black -Wthinner,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx4f2a2 -Bpyg4f2a2 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=13p,25,black \
    -B+t"Geoid model (EGM-2008) of Venezuela and Trinidad and Tobago" -O -K >> $ps
    
# Add legend
gmt psscale -Dg286/-1.0+w16.5c/0.4c+h+o0.0/0i+ml+e -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,0,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=8p,25,black \
    -Bg2f0.2a4+l"Color scale '33_blue_red': colour tables of IDL from the KDE scientific plotting tool [256, discrete, RGB, 252 segments, -T-55/25]" \
    -I0.2 -By+lm -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.7c/-2.3c+c50+w200k+l"Mercator projection. Scale (km)"+f \
    -UBL/-5p/-65p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P -Ia/thinnest,blue -Na -N1/thick,brown -Wthick,darkslategray -Df -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+f10p,17,black+jLB+a-0 >> $ps << EOF
293.20 10.58 Caracas
EOF
gmt psxy -R -J -Sc -W0.5p -Gred -O -K << EOF >> $ps
293.10 10.48 0.30c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
288.07 10.80 Maracaibo
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
288.37 10.63 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
291.30 10.38 Valencia
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
292 10.18 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
290.67 9.60 Barquisimeto
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
290.67 10.06 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
297.45 8.20 Ciudad
297.45 7.90 Guayana
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
297.35 8.36 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
296.2 9.35 Maturín
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
296.82 9.75 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
294.60 9.75 Barcelona
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
295.28 10.12 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
292.4 9.90 Maracay
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
292.4 10.25 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
295.93 10.46 Cumaná
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
295.83 10.46 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
289.9 8.63 Barinas
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
289.8 8.63 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
294.20 8.24 Ciudad Bolívar
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
296.45 8.14 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
287.87 7.76 San Cristóbal
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
287.77 7.76 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 -Glightgreen@60 >> $ps << EOF
291.80 7.80 San
291.80 7.55 Fernando
291.80 7.30 de Apure
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
292.53 7.89 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB+a-0 >> $ps << EOF
299.4 2.4 Boa
299.4 2.1 Vista
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
299.33 2.82 0.20c
EOF
# countries
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
297.8 11.20 TOBAGO
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
298.75 10.20 TRINIDAD
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,25,black+jLB >> $ps << EOF
289.1 5.0 C O L O M B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,25,black+jLB >> $ps << EOF
297.0 1.0 B  R  A  Z  I  L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,25,black+jLB >> $ps << EOF
298.85 6.10 GUYANA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f16p,25,firebrick4+jLB >> $ps << EOF
290.9 6.70 V  E  N  E  Z  U  E  L  A
EOF
# water
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,17,azure+jLB >> $ps << EOF
292.2 11.5 C a r i b b e a n  S e a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
288.07 9.9 Lake
288.0 9.6 Maracaibo
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
288.5 11.5 Golfo de
288.3 11.2 Venezuela
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
297.5 10.4 Golfo
297.5 10.1 de Paria
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
291.9 10.7 Golfo
291.9 10.4 Triste
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,26,blue1+jLB+a-342 >> $ps << EOF
295.35 7.4 Rio Orinoco
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-335 >> $ps << EOF
290.0 7.4 Apure
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
290.0 7.1 Arauca
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-80 >> $ps << EOF
298.0 6.8 Cuyuni
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
297.4 7.6 Embalse
297.4 7.3 de Guri
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-12 >> $ps << EOF
290.2 9.2 Portuguesa
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-9 >> $ps << EOF
292.90 7.9 Guarico
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-75 >> $ps << EOF
295.20 6.1 Caura
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-7 >> $ps << EOF
295.83 9.1 Tigre
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-290 >> $ps << EOF
296.0 5.7 Paragua
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,21,white+jLB >> $ps << EOF
298.0 9.2 Orinoco
298.0 8.8 Delta
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB >> $ps << EOF
288.2 6.35 Río Casanare
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-330 >> $ps << EOF
288.07 4.5 Río Meta
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-345 >> $ps << EOF
288.80 4.1 Río Vichada
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-350 >> $ps << EOF
289.8 3.6 Río Guaviare
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-330 >> $ps << EOF
290.7 2.85 Río Inírida
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-325 >> $ps << EOF
291.2 2.3 Río Guainía
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-293 >> $ps << EOF
298.75 1.8 Branco
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,blue1+jLB+a-350 >> $ps << EOF
297.9 2.9 Uraricoera
EOF

#
# geography
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,25,darkgreen+jLB+a-0 >> $ps << EOF
293.5 2.8 Amazon
293.5 2.3 Forests
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,darkred+jLB+a-0 >> $ps << EOF
293.8 5.0 Guiana Highlands
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,25,darkred+jLB+a-0 >> $ps << EOF
297.8 5.5 Gran
297.7 5.0 Sabana
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,darkred+jLB+a-50 >> $ps << EOF
294.2 4.8 Sierra Parima
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,21,black+jLB+a-320 >> $ps << EOF
288.3 8.1 Cordillera de Mérida
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,21,white+jLB+a-315 >> $ps << EOF
286.7 5.8 Los Andes
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,32,darkgreen+jLB+a-330 >> $ps << EOF
290.8 7.8 Los Llanos
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,darkred+jLB+a-0 >> $ps << EOF
290.1 12.1 Paraguaná
290.1 11.8 Peninsula
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,21,darkred+jLB+a-0 >> $ps << EOF
290.0 11.1 Lara-Falcón
290.0 10.8 Formación
290.0 10.5 (Coro)
EOF

# Add GMT logo
gmt logo -Dx7.0/-2.9+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y5.9c -N -O \
    -F+f10p,25,black+jLB >> $ps << EOF
3.0 13.6 World geoid image EGM2008 vertical datum 2.5 min resolution
EOF

# Convert to image file using GhostScript
gmt psconvert Geoid_VE.ps -A1.0c -E720 -Tj -Z
