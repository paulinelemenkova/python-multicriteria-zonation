#!/bin/bash

set -e
REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdsample dem_native.nc -Gdem_fine.nc -I0.0015 $REG
gmt grdgradient dem_fine.nc -Nt1 -A315/45 -Gshade.nc

gmt grdlandmask -Rdem_fine.nc -Di -N0/1/0/1/0 -Gmask.nc
gmt grdmath mask.nc 0 NAN = mask_nan.nc
gmt grdmath dem_fine.nc mask_nan.nc MUL = dem_masked.nc

gmt grdsample dem_masked.nc -Gdem_contour.nc -I0.006 $REG

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

gmt makecpt -Cglobe -T0/2531/50 -Z > dem.cpt
echo "N	gray85" >> dem.cpt

gmt begin Figure_02 pdf,png
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p \
          MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -G30/80/140 -L
  gmt grdimage dem_masked.nc -Cdem.cpt -Ishade.nc -Q
  gmt grdcontour dem_contour.nc -C500 -W0.3p,60/25/0
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-
  gmt basemap -Bxg1 -Byg0.5

  awk '{print $1,$2,$3,$4}' lakes.txt | gmt text -F+f7.5p,Helvetica-Oblique,26/63/102+jCM -Gwhite@30

  while read lon lat just name; do
    echo "$lon $lat" | gmt plot -Sc0.16c -Gwhite -W0.7p,black
    if [ "$just" = "R" ]; then jc="BR"; dx="-0.15c/0.08c"; else jc="BL"; dx="0.15c/0.08c"; fi
    echo "$lon $lat $name" | gmt text -F+f10p,Helvetica-Bold,black+j${jc} -D${dx}
  done < cities.txt

  echo "29.0 41.5 Black Sea" | gmt text -F+f12p,Helvetica-Oblique,azure+jCM
  echo "28.0 40.75 Sea of Marmara" | gmt text -F+f11p,Helvetica-Oblique,azure+jLM

  gmt colorbar -Cdem.cpt -DjTR+w5.3c/0.4c+o0.9c/0.7c+h+e -Ba500f250 -F+gwhite+p0.5p
  echo "0.775 0.965 Elevation (m)" | gmt text -R0/1/0/1 -JX18c/14.152c -F+f10p,Helvetica-Bold+jBC -N

  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p

  gmt text -R0/1/0/1 -JX18c/1.2c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-1.15c <<EOF
0.005 0.9 Elevation, SRTM 3 arc-sec (GMT earth_relief_03s), hillshade-draped, GMT globe CPT, 500 m contours. Provinces: geoBoundaries.
EOF
gmt end

echo "Done: Figure_02.pdf and Figure_02.png written to $(pwd)"
