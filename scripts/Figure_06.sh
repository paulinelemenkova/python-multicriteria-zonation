#!/bin/bash

set -e
REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdsample dem_native.nc -Gdem_fine.nc -I0.0015 $REG
gmt grdgradient dem_fine.nc -Nt1 -A315/45 -Gshade.nc
read -r NX NY <<< "$(gmt grdinfo -C dem_fine.nc | awk '{print $10, $11}')"

CLC_URL="/vsicurl/https://aquainfra-syke.a3s.fi/europe_clc_cog_raster/CLC2018ACC_V2018_20_cog.tif"
gdalwarp -overwrite -t_srs EPSG:4326 -te 26.0 39.0 31.0 42.0 -ts "$NX" "$NY" -r near \
  "$CLC_URL" clc_aoi.tif

python3 << 'PYEOF'
import rasterio
import numpy as np

with rasterio.open('clc_aoi.tif') as src:
    arr = src.read(1)
    profile = src.profile

mapping = {}
for c in [111,112,121,122,123,124,131,132,133,141,142]: mapping[c] = 1
for c in [211,212,213,221,222,223,241,242,243,244]:     mapping[c] = 2
mapping[311] = 3
mapping[312] = 4
mapping[313] = 5
for c in [231, 321]:      mapping[c] = 6
for c in [322, 323, 324]: mapping[c] = 7
for c in [331, 332, 333, 334]: mapping[c] = 8
for c in [521, 522, 523]: mapping[c] = 9
for c in [411, 421, 422, 511, 512]: mapping[c] = 10

out = np.zeros(arr.shape, dtype=np.uint8)
for code, cat in mapping.items():
    out[arr == code] = cat

profile.update(dtype=rasterio.uint8, nodata=0, count=1)
with rasterio.open('lc_cat.tif', 'w', **profile) as dst:
    dst.write(out, 1)
PYEOF

gmt grdconvert lc_cat.tif lc_raw.nc=nf
gmt grdsample lc_raw.nc -Glc_fine0.nc -Rdem_fine.nc -nn
gmt grdmath lc_fine0.nc 0 NAN = lc_fine.nc

curl -sfL --max-time 60 -o faults_nafz.gmt \
  "https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01/faults_nafz.gmt"

cat > faults_mta.gmt << 'EOFT'
>
26.532 39.574
26.538 39.568
26.550 39.546
>
27.695 39.294
27.698 39.289
27.702 39.281
27.705 39.277
>
28.370 41.347
28.362 41.356
28.354 41.364
28.352 41.372
28.343 41.381
28.339 41.382
28.338 41.378
28.343 41.368
28.343 41.362
28.338 41.360
28.319 41.366
28.310 41.366
>
29.070 41.174
29.055 41.181
29.051 41.191
29.059 41.201
29.057 41.206
29.049 41.209
29.034 41.211
29.029 41.210
29.023 41.206
29.011 41.206
29.002 41.209
28.999 41.215
29.000 41.224
28.994 41.225
28.985 41.222
28.978 41.229
28.973 41.235
28.968 41.239
>
29.246 41.055
29.250 41.036
29.252 41.025
29.257 41.010
>
29.574 41.020
29.567 41.000
29.561 40.983
29.558 40.980
>
29.159 40.437
29.216 40.436
29.241 40.435
29.323 40.429
29.364 40.427
29.445 40.417
29.536 40.407
29.605 40.405
29.686 40.416
29.767 40.427
29.810 40.426
29.857 40.438
29.910 40.443
29.985 40.453
30.017 40.454
30.105 40.486
>
27.891 40.129
27.967 40.104
28.031 40.091
28.099 40.087
28.176 40.085
28.241 40.066
28.272 40.054
28.313 40.049
28.363 40.047
28.454 40.039
28.490 40.035
>
26.502 40.373
26.475 40.356
26.446 40.339
26.384 40.319
26.360 40.315
EOFT

cat > cities.txt << 'EOCT'
26.5557 41.6771 R Edirne
27.5167 40.9833 R Tekirdag
28.9784 41.0082 L Istanbul
26.4142 40.1553 L Canakkale
27.9773 40.3524 L Bandirma
29.0665 40.1826 L Bursa
29.9208 40.7654 L Izmit
30.3781 40.7569 L Sakarya
EOCT

cat > lakes.txt << 'EOLK'
30.25 40.715 Sapanca L.
29.52 40.43 Iznik L.
27.75 40.18 Manyas L.
EOLK

GB="https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/main/releaseData/gbOpen/TUR/ADM1/geoBoundaries-TUR-ADM1.geojson"
curl -sfL --max-time 150 -o tur.geojson "$GB"
ogr2ogr -f OGR_GMT provinces.gmt tur.geojson -clipsrc 26.0 39.0 31.0 42.0

cat > lc.cpt << 'EOCPT'
0.5	200/60/60	1.5	200/60/60
1.5	255/220/130	2.5	255/220/130
2.5	40/120/40	3.5	40/120/40
3.5	20/90/85	4.5	20/90/85
4.5	100/160/70	5.5	100/160/70
5.5	180/210/120	6.5	180/210/120
6.5	150/140/60	7.5	150/140/60
7.5	180/150/120	8.5	180/150/120
8.5	30/80/140	9.5	30/80/140
9.5	140/200/230	10.5	140/200/230
N	gray85
EOCPT

gmt begin Figure_06 pdf E300
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p \
          MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -G30/80/140 -L
  gmt grdimage lc_fine.nc -Clc.cpt -Ishade.nc -Q
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-
  gmt plot faults_mta.gmt -W0.5p,40/40/40
  gmt plot faults_nafz.gmt -W2.2p,180/0/0
  gmt basemap -Bxg1 -Byg0.5

  echo "29.6 41.8 Black Sea" | gmt text -F+f12p,Helvetica-Bold,azure+jCM
  echo "28.0 40.75 Sea of Marmara" | gmt text -F+f11p,Helvetica-Oblique,azure+jLM

  awk '{print $1,$2,$3,$4}' lakes.txt | gmt text -F+f7.5p,Helvetica-Oblique,26/63/102+jCM -Gwhite@30

  while read -r lon lat just name; do
    echo "$lon $lat" | gmt plot -Sc0.16c -Gwhite -W0.7p,black
    if [ "$just" = "R" ]; then jc="BR"; dx="-0.15c/0.08c"; else jc="BL"; dx="0.15c/0.08c"; fi
    echo "$lon $lat $name" | gmt text -F+f9p,Helvetica-Bold,black+j${jc} -Gwhite@20 -C1p/1p -D${dx}
  done < cities.txt

  echo "27.0 40.62 NORTH ANATOLIAN FAULT (active)" | gmt text -F+f8p,Helvetica-Bold,180/0/0+a-8+jCM -Gwhite@25

  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p

  gmt legend -Dx0/-0.4c+w18c+jTL -F+gwhite << EOLG
N 3
H 10p,Helvetica-Bold LEGEND
S 0.3c s 0.32c 200/60/60 0.3p 0.55c Built-up Areas
S 0.3c s 0.32c 255/220/130 0.3p 0.55c Cropland
S 0.3c s 0.32c 40/120/40 0.3p 0.55c Broadleaf Forest
S 0.3c s 0.32c 20/90/85 0.3p 0.55c Coniferous Forest
S 0.3c s 0.32c 100/160/70 0.3p 0.55c Mixed Forest
S 0.3c s 0.32c 180/210/120 0.3p 0.55c Grassland
S 0.3c s 0.32c 150/140/60 0.3p 0.55c Shrubland
S 0.3c s 0.32c 180/150/120 0.3p 0.55c Bare Land
S 0.3c s 0.32c 30/80/140 0.3p 0.55c Water - Marine
S 0.3c s 0.32c 140/200/230 0.3p 0.55c Water - Freshwater
S 0.3c - 0.6c 180/0/0 2p 0.55c NAF (active)
S 0.3c - 0.6c 40/40/40 0.5p 0.55c Other fault
EOLG

  gmt text -R0/1/0/1 -JX18c/1.6c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-4.3c << EOCR
0.005 0.9 Land cover: CORINE Land Cover 2018 (CLC2018), Copernicus Land Monitoring Service / European Environment Agency,
0.005 0.58 reclassified from 44 CLC Level-3 classes into 10 groups. Faults: MTA (context) plus North Anatolian Fault active
0.005 0.26 trace (Marmara segment). Relief: SRTM 3 arc-sec. Provinces: geoBoundaries.
EOCR
gmt end

echo "Done: Figure_06.pdf and Figure_06.png written to $(pwd)"
