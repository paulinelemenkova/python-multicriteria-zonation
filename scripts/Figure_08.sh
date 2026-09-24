#!/bin/bash

set -e
REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdconvert dem_native.nc dem_native.tif=gd:GTiff
gdalwarp -overwrite -s_srs EPSG:4326 -t_srs EPSG:5254 -tr 150 150 -r bilinear \
         -dstnodata -32768 dem_native.tif dem5254.tif

cat > grass_job.sh <<'JOB'
set -e
r.in.gdal -o input=dem5254.tif output=dem --overwrite --quiet
g.region raster=dem
r.slope.aspect elevation=dem aspect=aspect --overwrite --quiet
r.mapcalc --overwrite --quiet expression="aspect_c = float(if(aspect==0, null(), (450.0 - aspect) % 360.0))"
r.out.gdal -f -c input=aspect_c output=aspect5254.tif format=GTiff type=Float32 \
           nodata=-9999 createopt="COMPRESS=DEFLATE" --overwrite --quiet
JOB
grass -c dem5254.tif ./grassloc --exec bash grass_job.sh

gdalwarp -overwrite -s_srs EPSG:5254 -t_srs EPSG:4326 -te 26.0 39.0 31.0 42.0 \
         -tr 0.0015 0.0015 -r near -dstnodata -9999 aspect5254.tif aspect_ll.tif
gmt grdconvert aspect_ll.tif aspect_ll.nc=nf

gmt grdlandmask -Raspect_ll.nc -Di -N0/1/0/1/0 -Gmask.nc
gmt grdmath mask.nc 0 NAN = mask_nan.nc
gmt grdmath aspect_ll.nc mask_nan.nc MUL = aspect_masked.nc

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

cat > aspect.cpt << 'CPT'
0	255/0/0	60	255/255/0
60	255/255/0	120	0/255/0
120	0/255/0	180	0/255/255
180	0/255/255	240	0/0/255
240	0/0/255	300	255/0/255
300	255/0/255	360	255/0/0
B	255/0/0
F	255/0/0
N	gray85
CPT

gmt begin Figure_08 pdf,png
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p \
          MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -Ggray85 -L
  gmt grdimage aspect_masked.nc -Caspect.cpt -Q
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-
  gmt basemap -Bxg1 -Byg0.5
  awk '{print $1,$2,$3,$4}' lakes.txt | gmt text -F+f7.5p,Helvetica-Oblique,26/63/102+jCM -Gwhite@30
  while read lon lat just name; do
    echo "$lon $lat" | gmt plot -Sc0.16c -Gwhite -W0.7p,black
    if [ "$just" = "R" ]; then jc="BR"; dx="-0.15c/0.08c"; else jc="BL"; dx="0.15c/0.08c"; fi
    echo "$lon $lat $name" | gmt text -F+f9p,Helvetica-Bold,black+j${jc} -Gwhite@20 -C1p/1p -D${dx}
  done < cities.txt

  echo "29.0 41.5 Black Sea" | gmt text -F+f12p,Helvetica-Oblique,20/55/95+jCM
  echo "28.0 40.75 Sea of Marmara" | gmt text -F+f11p,Helvetica-Oblique,20/55/95+jLM

  gmt colorbar -Caspect.cpt -DjTR+w6c/0.4c+o0.4c/0.4c+h -B0 -F+gwhite+p0.5p
  echo "0.811 0.985 Aspect (Compass Direction)" | gmt text -R0/1/0/1 -JX18c/14.152c -F+f10p,Helvetica-Bold+jBC -N
  gmt text -R0/1/0/1 -JX18c/14.152c -F+f7p,Helvetica,black+jTC -N <<EOF
0.644 0.9385 N
0.686 0.9385 NE
0.728 0.9385 E
0.769 0.9385 SE
0.811 0.9385 S
0.853 0.9385 SW
0.894 0.9385 W
0.936 0.9385 NW
EOF

  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p

  gmt text -R0/1/0/1 -JX18c/1.2c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-1.15c <<EOF
0.005 0.9 Aspect (compass direction), SRTM 3 arc-sec (GMT earth_relief_03s), computed via r.slope.aspect (GRASS). Provinces: geoBoundaries.
EOF
gmt end

echo "Done: Figure_08.pdf and Figure_08.png written to $(pwd)"
