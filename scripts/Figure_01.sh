#!/usr/bin/env bash
set -e
IN=${IN:-$PWD/input}; OUT=${OUT:-$PWD}; mkdir -p "$IN" "$OUT"

RAW=https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01
GB=https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/main/releaseData/gbOpen/TUR/ADM1/geoBoundaries-TUR-ADM1.geojson

[ -s "$IN/naf_northern.gmt" ] || curl -sfL "$RAW/faults_nafz.gmt" -o "$IN/naf_northern.gmt"

if [ ! -s "$IN/istanbul.gmt" ] || [ ! -s "$IN/kocaeli.gmt" ]; then
  curl -sfL --max-time 150 -o /tmp/tur.geojson "$GB"
  ogr2ogr -f OGR_GMT "$IN/istanbul.gmt" /tmp/tur.geojson -where "shapeName LIKE '%stanbul%'"
  ogr2ogr -f OGR_GMT "$IN/kocaeli.gmt"  /tmp/tur.geojson -where "shapeName LIKE '%ocaeli%'"
fi

[ -s "$IN/cities.txt" ] || cat > "$IN/cities.txt" <<'EOF'
28.9784 41.0082 Istanbul
29.9200 40.7650 Izmit
EOF

cd "$OUT"
ps=fig1.ps
R=-R27.4/30.9/40.15/41.75
J=-JM16c

gmt set FONT_ANNOT_PRIMARY 9p,Helvetica,black FONT_LABEL 10p,Helvetica,black \
    FONT_TITLE 12p,Helvetica-Bold,black MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p,black \
    MAP_GRID_PEN_PRIMARY 0.4p,white MAP_TICK_LENGTH_PRIMARY 0.12c \
    MAP_ANNOT_OFFSET_PRIMARY 0.22c MAP_LABEL_OFFSET 0.20c \
    FORMAT_GEO_MAP ddd.xF PS_PAGE_ORIENTATION portrait PS_CHAR_ENCODING ISOLatin1+

gmt grdcut @earth_relief_03s $R -Grelief.nc
gmt grdgradient relief.nc -Nt1.0 -A315 -Ghillshade.nc
gmt makecpt -Cgeo -T-2500/2500/50 -Z > topo.cpt
gmt grdimage relief.nc -Ihillshade.nc -Ctopo.cpt $R $J \
    -Bxa1f0.5g1 -Bya0.5f0.25g0.5 \
    -BWSne+t"Study area: Istanbul and Kocaeli provinces along the North Anatolian Fault corridor" \
    -Xc -Y4c -K -P > $ps
gmt pscoast $R $J -Di -Sroyalblue1@60 -A50 -O -K >> $ps

gmt psxy $IN/istanbul.gmt $R $J -G255/120/120@55 -O -K >> $ps
gmt psxy $IN/kocaeli.gmt  $R $J -G245/205/90@45 -O -K >> $ps
gmt psxy $IN/istanbul.gmt $R $J -W1.3p,220/20/20 -O -K >> $ps
gmt psxy $IN/kocaeli.gmt  $R $J -W1.3p,190/120/0 -O -K >> $ps
gmt pscoast $R $J -Di -W0.5p,black -N1/0.6p,gray30 -A30 -O -K >> $ps

gmt psxy $IN/naf_northern.gmt $R $J -W2.2p,red -O -K >> $ps
gmt pstext $R $J -F+f8.5p,Helvetica-BoldOblique,red+a6+jML -Gwhite@30 -O -K >> $ps << 'TXT'
27.62 40.60 North Anatolian Fault Zone (northern strand)
TXT

gmt psxy $IN/cities.txt $R $J -Sc0.22c -Gblack -W0.6p,white -O -K >> $ps
gmt pstext $R $J -F+f10.5p,Helvetica-Bold,black+jLM -Dj0.18c/0c -Gwhite@25 -O -K >> $ps << 'TXT'
28.9784 41.0082 Istanbul
29.9200 40.7650 Izmit (Kocaeli)
TXT
gmt psxy $R $J -Sc0.10c -Ggray25 -O -K >> $ps << 'TXT'
27.5100 40.9800
29.0600 40.1900
TXT
gmt pstext $R $J -F+f8p,Helvetica,gray20+jRM -Dj0.14c/0c -O -K >> $ps << 'TXT'
27.5100 40.9800 Tekirdag
29.0600 40.1900 Bursa
TXT

gmt pstext $R $J -F+f9p,Helvetica-Oblique,white+jCM -O -K >> $ps << 'TXT'
29.55 41.60 Black Sea
TXT
gmt pstext $R $J -F+f9p,Helvetica-Oblique,navy+jCM -O -K >> $ps << 'TXT'
28.55 40.62 Sea of Marmara
TXT

gmt pstext $R $J -F+f11p,Helvetica-Bold,220/20/20+jCM -O -K >> $ps << 'TXT'
28.55 41.13 ISTANBUL
TXT
gmt pstext $R $J -F+f11p,Helvetica-Bold,150/95/0+jCM -O -K >> $ps << 'TXT'
29.90 40.86 KOCAELI
TXT

gmt psbasemap $R $J -Lg28.0/40.30+c40.9+w40k+f+u+l"km" \
    -Tdg30.55/41.40+w0.7c+f2+l,,,N --FONT_TITLE=9p -O -K >> $ps

gmt pslegend $R $J -DjBR+w4.3c+o0.15c/0.15c+l1.2 -F+gwhite@10+p0.8p,gray40 -O -K << 'LEG' >> $ps
S 0.25c s 0.35c 255/120/120@55 0.6p,220/20/20 0.7c Istanbul province
S 0.25c s 0.35c 245/205/90@45 0.6p,190/120/0 0.7c Kocaeli province
S 0.25c - 0.45c - 2.2p,red 0.7c NAFZ (N strand)
S 0.25c c 0.16c black 0.4p,white 0.7c Provincial centre
LEG

gmt psscale -Dx16.7c/0c+w7.8c/0.35c+jBL+e -Ctopo.cpt -R -J \
    -Bxa1000f500+l"Elevation (m)" -O -K >> $ps

gmt psbasemap $R $J -O -K -DjTL+w3.0c+o0.15c/0.15c+stmp >> $ps
read x0 y0 w h < tmp
gmt pscoast -Rg -JG34/39/$w -Da -Glightgoldenrod1 -A5000 -Bga -Wfaint \
    --MAP_FRAME_PEN=thick,white -ETR+gred -Sroyalblue1 -O -K -X$x0 -Y$y0 >> $ps
gmt psxy -Rg -JG34/39/$w -Sc0.10c -Gblack -O -K >> $ps << 'PT'
29.4 40.9
PT
gmt psxy $R $J -O -K -T -X-${x0} -Y-${y0} >> $ps

gmt pstext $R $J -F+f7p,Helvetica,gray30+jTL -Y-0.9c -N -O >> $ps << 'TXT'
27.4 40.15 Relief: SRTM 3 arc-sec (GMT earth_relief_03s). Provinces: geoBoundaries TUR ADM1 (CC BY). Fault trace: GEM Global Active Faults / Emre et al. (2018). CRS: WGS 84.
TXT

gmt psconvert $ps -A0.3c -P -Tf -F"$OUT/Figure_01"
gmt psconvert $ps -A0.3c -P -Tg -E300 -F"$OUT/Figure_01"
