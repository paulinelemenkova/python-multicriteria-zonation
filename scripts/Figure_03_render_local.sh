#!/bin/bash
set -e

GEODIR="${1:?Usage: $0 <path to geology_output folder from Figure_03_prepare_geology_local.sh>}"
GEODIR="$(cd "$GEODIR" && pwd)"
[ -f "$GEODIR/lith.tif" ] || { echo "ERROR: lith.tif not found in $GEODIR"; exit 1; }
[ -f "$GEODIR/faults_mta.gmt" ] || { echo "ERROR: faults_mta.gmt not found in $GEODIR"; exit 1; }

WORKDIR="$(pwd)/figure03_render"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

echo "=== North Anatolian Fault active trace (same source as Figures 1-2) ==="
curl -sfL --max-time 60 -o faults_nafz.gmt "https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01/faults_nafz.gmt"

echo "=== SRTM 3 arc-sec relief ==="
gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdsample dem_native.nc -Gdem_fine.nc -I0.0015 $REG
gmt grdgradient dem_fine.nc -Nt1 -A315/45 -Gshade.nc

echo "=== Warp geology raster to match dem_fine.nc's EXACT grid ==="
NCOLS=$(gmt grdinfo -C dem_fine.nc | awk '{print $10}')
NROWS=$(gmt grdinfo -C dem_fine.nc | awk '{print $11}')
echo "target grid: ${NCOLS} x ${NROWS}"
gdalwarp -overwrite -r near -te 26.0 39.0 31.0 42.0 -ts "$NCOLS" "$NROWS" -t_srs EPSG:4326 \
  "$GEODIR/lith.tif" lith_fine.tif
gmt grdconvert lith_fine.tif lith_fine_raw.nc=nf
gmt grdsample lith_fine_raw.nc -Glith_fine.nc -Rdem_fine.nc -nn

echo "=== Land mask ==="
gmt grdlandmask -Rdem_fine.nc -Di -N0/1/0/1/0 -Gmask.nc
gmt grdmath mask.nc 0 NAN = mask_nan.nc
gmt grdmath lith_fine.nc mask_nan.nc MUL = lith_masked.nc

echo "=== City / lake labels, provinces ==="
cat > cities.txt << 'EOF'
26.5557 41.6771 R Edirne
27.5167 40.9833 R Tekirdag
28.9784 41.0082 L Istanbul
26.4142 40.1553 L Canakkale
27.9773 40.3524 L Bandirma
29.0665 40.1826 L Bursa
29.9208 40.7654 L Izmit
30.3781 40.7569 L Sakarya
EOF
cat > lakes.txt << 'EOF'
30.25 40.715 Sapanca L.
29.52 40.43 Iznik L.
27.75 40.18 Manyas L.
EOF
GB="https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/main/releaseData/gbOpen/TUR/ADM1/geoBoundaries-TUR-ADM1.geojson"
curl -sfL --max-time 150 -o tur.geojson "$GB"
ogr2ogr -f OGR_GMT provinces.gmt tur.geojson -clipsrc 26.0 39.0 31.0 42.0

cp "$GEODIR/faults_mta.gmt" .

cat > geo.cpt << 'CPT'
0.5	255/255/200	1.5	255/255/200
1.5	255/200/120	2.5	255/200/120
2.5	200/140/60	3.5	200/140/60
3.5	150/200/120	4.5	150/200/120
4.5	80/150/80	5.5	80/150/80
5.5	170/220/230	6.5	170/220/230
6.5	110/140/160	7.5	110/140/160
7.5	220/60/60	8.5	220/60/60
8.5	230/150/180	9.5	230/150/180
B	255/255/200
F	230/150/180
N	gray85
CPT

echo "=== Render ==="
gmt begin Figure_03 pdf,png
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p \
          MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -G30/80/140 -L
  gmt grdimage lith_masked.nc -Cgeo.cpt -Ishade.nc -Q
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-
  gmt plot faults_mta.gmt -W0.5p,40/40/40
  gmt plot faults_nafz.gmt -W2.2p,180/0/0
  gmt basemap -Bxg1 -Byg0.5

  echo "29.6 41.8 Black Sea" | gmt text -F+f12p,Helvetica-Bold,azure+jCM
  echo "28.0 40.75 Sea of Marmara" | gmt text -F+f11p,Helvetica-Oblique,azure+jLM

  awk '{print $1,$2,$3,$4}' lakes.txt | gmt text -F+f7.5p,Helvetica-Oblique,26/63/102+jCM -Gwhite@30

  while read lon lat just name; do
    echo "$lon $lat" | gmt plot -Sc0.16c -Gwhite -W0.7p,black
    if [ "$just" = "R" ]; then jc="BR"; dx="-0.15c/0.08c"; else jc="BL"; dx="0.15c/0.08c"; fi
    echo "$lon $lat $name" | gmt text -F+f9p,Helvetica-Bold,black+j${jc} -Gwhite@20 -C1p/1p -D${dx}
  done < cities.txt

  echo "27.0 40.62 NORTH ANATOLIAN FAULT (active)" | gmt text -F+f8p,Helvetica-Bold,180/0/0+a-8+jCM -Gwhite@25

  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p

  gmt legend -Dx0/-0.4c+w18c+jTL -F+gwhite <<EOF
N 3
H 10p,Helvetica-Bold LEGEND
S 0.3c s 0.32c 255/255/200 0.3p 0.55c Q  Quaternary
S 0.3c s 0.32c 255/200/120 0.3p 0.55c N  Neogene
S 0.3c s 0.32c 200/140/60 0.3p 0.55c P  Paleogene
S 0.3c s 0.32c 150/200/120 0.3p 0.55c K  Cretaceous
S 0.3c s 0.32c 80/150/80 0.3p 0.55c J  Jurassic
S 0.3c s 0.32c 170/220/230 0.3p 0.55c Tr  Triassic
S 0.3c s 0.32c 110/140/160 0.3p 0.55c Pz  Paleozoic
S 0.3c s 0.32c 220/60/60 0.3p 0.55c V  Volcanic
S 0.3c s 0.32c 230/150/180 0.3p 0.55c G  Granitic
S 0.3c - 0.6c 180/0/0 2p 0.55c NAF (active)
S 0.3c - 0.6c 40/40/40 0.5p 0.55c Other fault
EOF

  gmt text -R0/1/0/1 -JX18c/1.6c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-4.3c <<EOF
0.005 0.9 Geology: MTA 1:500,000 Geology Map of Turkey (1961), digitised by Orr and Associates (2002); units reclassified by
0.005 0.58 age/lithology into 9 groups. Faults: same source (context) plus North Anatolian Fault active trace (Marmara segment).
0.005 0.26 Relief: SRTM 3 arc-sec. Provinces: geoBoundaries.
EOF
gmt end

echo ""
echo "Done: $WORKDIR/Figure_03.pdf and Figure_03.png"
