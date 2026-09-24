#!/usr/bin/env bash
IN=${IN:-$PWD/fig9_input}; mkdir -p "$IN"
export IN

if [ ! -s "$IN/lith7_crop.b64" ]; then
cat > "$IN/lith7_crop.b64" <<'B64'
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
B64
fi
if [ "${RECOMPUTE_CHIRPS:-0}" = "1" ]; then
GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR python3 - "$IN/chirps_rx1day_2015_2024.asc" <<'PY'
import sys, rasterio, numpy as np, datetime as dt
from rasterio.windows import from_bounds
from concurrent.futures import ThreadPoolExecutor
W, S, E, N = 27.8, 40.3, 30.7, 41.7
base = "https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_daily/cogs/p05/{y}/chirps-v2.0.{y}.{m:02d}.{d:02d}.cog"
days = []; d = dt.date(2015, 1, 1)
while d <= dt.date(2024, 12, 31): days.append(d); d += dt.timedelta(1)
def get(day):
    with rasterio.open("/vsicurl/" + base.format(y=day.year, m=day.month, d=day.day)) as s:
        w = from_bounds(W, S, E, N, s.transform).round_offsets().round_lengths()
        a = s.read(1, window=w).astype("float32"); a[a < 0] = np.nan
        return day, a, s.window_transform(w)
with ThreadPoolExecutor(64) as ex: res = list(ex.map(get, days))
tr = res[0][2]; shp = res[0][1].shape; mx = {}
for day, a, _ in res: mx[day.year] = np.fmax(mx.get(day.year, np.full(shp, np.nan)), a)
rx = np.nanmean(np.stack([mx[y] for y in sorted(mx)]), 0)
with open(sys.argv[1], "w") as f:
    f.write(f"ncols {shp[1]}\nnrows {shp[0]}\nxllcorner {tr.c:.4f}\nyllcorner {tr.f + tr.e * shp[0]:.4f}\ncellsize {tr.a:.4f}\nNODATA_value -9999\n")
    for row in np.where(np.isnan(rx), -9999, rx): f.write(" ".join(f"{v:.1f}" for v in row) + "\n")
PY
elif [ ! -s "$IN/chirps_rx1day_2015_2024.asc" ]; then
cat > "$IN/chirps_rx1day_2015_2024.asc" <<'ASC'
ncols 58
nrows 28
xllcorner 27.8000
yllcorner 40.3000
cellsize 0.0500
NODATA_value -9999
38.4 39.2 37.5 36.8 37.0 34.4 37.2 40.5 22.6 22.9 23.6 23.9 24.4 25.0 26.3 26.4 26.5 27.1 27.2 27.3 27.5 27.6 27.5 27.7 27.3 27.6 27.6 27.7 27.9 27.6 27.8 27.8 27.9 28.1 28.5 28.9 28.9 29.2 29.0 29.7 29.8 30.1 29.8 29.9 30.6 30.4 30.4 30.5 30.4 30.7 30.9 31.2 31.1 31.3 31.7 31.3 31.3 31.5
39.4 39.5 38.3 38.0 35.0 38.8 39.0 38.8 22.6 22.9 23.5 23.8 24.0 24.8 25.8 25.9 25.8 26.2 26.3 26.6 26.7 26.7 26.7 27.0 26.6 27.4 27.6 27.7 27.4 27.2 27.4 27.7 27.7 27.7 28.1 28.2 28.1 28.3 28.0 28.6 28.7 28.8 28.7 28.8 29.6 29.4 29.2 29.6 29.6 29.9 30.0 30.3 30.3 30.4 30.6 30.2 30.3 30.4
37.9 39.8 41.9 40.3 40.1 38.3 41.3 41.4 44.1 44.2 23.5 23.8 24.1 24.8 25.8 25.9 25.8 26.1 26.3 26.5 26.6 26.6 26.6 26.9 26.5 27.4 27.6 27.7 27.5 27.4 27.4 27.6 27.6 27.7 28.0 28.1 27.9 28.1 27.8 28.2 28.3 28.3 28.2 28.2 28.8 28.7 28.6 28.9 28.9 29.1 29.4 29.6 29.5 29.6 29.8 29.4 29.4 29.6
38.0 39.2 42.2 44.6 42.2 42.1 48.9 48.0 49.7 45.3 43.0 23.3 23.8 24.4 25.0 25.1 25.4 25.7 25.8 25.6 26.1 26.2 26.3 26.6 26.3 27.1 27.2 27.4 27.6 27.4 27.4 27.4 27.4 27.5 27.9 27.9 27.8 27.8 27.4 27.5 27.5 27.4 27.2 27.2 27.7 27.8 27.6 27.8 27.5 28.0 28.1 28.3 28.5 28.6 28.4 28.1 28.1 27.8
36.7 38.9 39.7 44.3 48.3 45.6 50.3 48.7 50.2 45.0 42.4 43.8 46.3 25.4 25.9 26.0 26.5 26.9 27.1 27.1 27.2 27.2 27.0 27.5 27.1 27.9 28.2 28.3 28.5 28.2 28.3 28.3 28.2 28.3 28.7 28.7 28.3 28.4 28.2 28.2 28.1 27.8 27.6 27.6 27.7 28.1 27.9 27.9 27.5 27.8 27.8 27.9 27.9 27.9 28.3 28.1 28.3 28.0
37.8 40.6 43.3 47.2 47.0 47.8 48.5 48.5 47.5 44.9 43.3 42.5 44.9 51.2 52.9 52.1 55.3 27.8 28.0 28.3 28.5 28.6 28.5 29.1 28.5 29.1 29.1 29.0 29.1 28.5 28.6 28.3 28.2 28.2 28.4 28.7 28.6 28.7 27.9 27.9 27.8 27.4 27.6 27.4 27.3 27.8 27.7 27.3 27.2 27.1 27.1 27.3 27.4 27.4 27.6 27.4 27.7 27.5
48.0 41.6 41.5 44.0 45.2 45.9 50.5 47.3 50.8 45.1 43.3 43.7 44.0 47.6 48.3 50.3 53.0 55.6 55.2 29.4 29.7 30.0 30.6 31.2 30.7 30.6 30.2 29.7 29.3 28.8 28.7 28.2 28.0 28.1 28.4 28.5 28.6 28.5 27.7 27.5 27.3 27.1 27.1 27.0 26.8 27.0 26.9 26.3 26.4 26.2 26.1 26.2 26.2 26.4 26.3 26.2 26.5 26.8
43.1 41.5 38.4 42.7 42.9 43.6 47.4 50.1 48.0 46.1 44.2 48.2 47.0 48.7 49.5 54.0 51.4 53.4 57.0 59.1 58.4 62.2 65.9 33.0 32.9 31.9 31.0 30.0 29.4 28.2 28.1 27.6 27.7 27.8 28.3 28.1 27.9 27.6 27.2 27.4 27.0 26.7 26.6 26.4 27.1 26.6 26.4 25.9 25.5 26.1 26.1 25.3 25.6 25.8 25.6 25.9 26.3 26.2
42.0 41.3 43.5 41.9 40.9 43.0 42.4 46.0 46.6 49.3 49.8 47.5 49.3 49.4 49.0 48.0 53.1 56.5 56.8 57.1 59.4 61.8 66.6 64.7 68.4 64.5 63.3 64.7 29.7 28.0 27.8 27.6 27.9 28.3 28.6 28.9 28.7 28.1 27.2 26.9 26.4 26.9 26.2 26.0 26.2 26.0 25.8 25.7 24.9 24.9 24.8 25.1 25.4 25.6 26.1 25.3 25.6 25.7
38.8 40.4 41.2 41.3 38.2 39.4 41.3 44.2 45.6 44.3 44.5 45.6 47.6 46.9 47.0 50.1 48.5 55.3 54.6 57.0 62.2 66.4 67.9 65.1 71.9 71.0 66.7 61.9 58.7 55.5 56.4 60.3 61.2 62.1 64.2 30.8 30.3 29.1 28.0 27.2 26.6 27.2 26.3 26.1 26.4 26.0 25.7 25.9 60.4 59.6 60.8 61.7 25.2 25.3 26.0 25.2 25.5 25.7
39.1 39.5 41.7 44.5 41.8 41.9 44.2 45.5 45.5 45.3 45.0 47.6 47.2 46.6 46.5 51.3 48.2 53.0 52.8 53.5 60.9 59.2 64.1 72.6 79.1 73.6 66.5 64.0 59.5 58.7 56.5 58.3 58.1 63.9 64.8 66.4 67.4 63.6 60.0 67.3 62.6 56.8 59.5 59.8 24.9 60.5 61.1 60.3 57.9 64.5 60.9 61.4 68.2 69.0 68.8 69.8 25.2 25.5
39.4 40.6 42.6 42.1 43.2 43.8 46.1 46.2 45.3 46.3 46.8 46.9 46.3 47.7 48.2 50.4 49.2 52.0 51.2 52.3 57.6 60.3 67.2 70.8 78.5 69.4 65.3 61.9 57.4 58.8 57.6 57.7 62.1 61.9 65.6 68.4 69.3 62.5 61.1 69.6 58.0 55.3 57.8 59.6 62.4 60.2 61.1 63.1 64.0 62.0 63.5 63.3 65.7 68.0 62.6 69.6 70.1 70.4
42.1 42.4 42.6 42.0 40.8 42.9 42.4 42.9 41.1 42.3 42.8 43.1 44.4 48.2 45.2 48.5 48.2 45.6 49.7 49.1 50.7 53.3 61.0 64.2 67.4 66.6 63.3 56.7 55.4 56.0 59.1 57.4 59.5 62.5 68.9 66.1 65.8 66.5 60.8 60.1 61.3 53.6 59.6 60.0 62.5 58.5 54.3 54.9 58.4 59.5 60.7 66.0 63.9 66.4 64.4 63.7 67.3 65.6
40.2 38.4 40.6 43.6 40.9 41.6 40.2 25.3 25.4 25.5 25.6 45.5 46.3 46.1 46.8 48.4 49.2 45.4 45.9 45.6 46.6 50.5 53.4 61.3 61.9 59.8 57.6 56.1 56.7 55.9 56.7 57.7 55.6 60.9 65.4 67.2 65.1 63.7 56.4 61.6 60.2 61.7 58.0 52.1 56.6 55.0 56.5 57.1 61.2 62.9 61.0 63.9 62.2 68.1 66.0 68.1 71.4 72.4
37.2 38.8 40.5 40.8 41.1 25.6 25.8 25.9 26.0 26.7 26.6 26.6 26.8 44.1 44.0 46.9 48.6 46.5 45.9 42.5 44.2 45.5 53.6 56.1 53.2 55.7 52.5 53.1 53.5 52.2 52.6 53.2 54.0 57.1 62.0 59.1 56.4 58.6 53.3 62.8 61.0 60.6 57.3 52.9 56.1 56.1 58.1 59.2 60.7 61.4 61.4 73.1 72.2 72.4 60.1 66.6 68.8 70.2
24.4 24.6 24.7 25.1 25.6 25.6 25.8 25.9 26.0 26.7 26.4 26.4 26.5 26.5 26.7 26.6 26.6 26.2 25.7 24.1 26.0 26.5 27.8 53.4 47.4 47.4 48.8 45.9 52.2 53.2 53.7 53.9 52.8 54.6 57.2 59.1 58.1 52.8 53.2 59.4 58.1 56.6 55.6 52.4 54.5 59.3 58.0 60.3 61.4 62.0 64.5 68.9 65.9 60.3 63.2 62.7 66.7 68.3
24.6 24.8 24.9 25.2 25.5 25.6 25.7 25.7 25.7 26.3 26.8 26.8 27.2 26.6 26.8 26.6 26.6 26.6 26.1 25.7 26.7 27.3 28.2 28.6 53.3 50.0 47.6 50.7 50.8 52.0 51.4 51.7 53.0 55.0 53.8 54.4 54.0 49.1 48.4 57.0 56.8 56.4 56.5 63.5 59.2 59.1 60.9 59.5 63.0 67.3 76.2 81.4 75.6 67.3 70.9 63.4 67.5 66.0
25.1 25.0 25.1 25.6 25.8 25.8 25.7 25.9 25.9 26.5 26.6 26.6 26.6 26.6 26.6 26.5 27.0 27.0 26.7 26.2 27.0 27.4 28.1 28.7 28.0 52.5 52.7 54.0 54.5 52.0 53.0 53.5 55.7 55.1 54.9 55.6 57.6 54.5 53.9 58.6 52.4 59.6 58.2 58.1 63.0 63.9 63.7 61.7 60.7 66.7 71.1 83.5 76.1 67.2 69.3 69.5 59.7 64.2
25.3 25.1 25.4 25.6 25.9 25.8 25.8 25.9 25.9 26.3 26.5 26.5 26.5 26.5 26.5 26.5 27.0 27.1 26.9 26.5 27.2 27.3 27.8 28.3 27.7 27.9 28.3 28.5 28.7 27.3 52.6 54.3 53.2 51.6 57.2 53.6 53.0 51.3 51.7 60.4 57.2 65.5 65.6 65.5 64.8 65.3 56.1 57.8 60.8 64.5 68.6 71.2 68.8 66.9 70.7 66.8 67.8 62.0
26.4 26.3 26.2 26.3 26.9 26.7 26.8 27.2 27.1 27.6 27.7 27.5 27.4 27.2 26.8 26.7 26.8 27.1 26.8 26.6 26.8 26.6 27.1 27.3 26.5 26.8 27.9 28.3 28.3 28.3 28.0 57.3 57.4 55.1 58.7 56.6 53.9 51.2 46.6 57.3 65.6 74.7 72.8 65.5 66.7 65.7 60.2 64.0 63.7 63.6 68.8 69.2 67.0 68.3 72.7 69.1 67.2 67.6
26.7 27.0 27.0 26.9 27.2 26.9 26.9 27.0 26.8 27.2 27.3 27.3 27.1 27.2 26.8 26.7 26.5 26.5 26.6 26.2 26.0 26.1 47.4 52.5 48.9 50.5 53.6 61.5 62.2 60.9 56.8 58.8 56.1 54.7 54.8 59.4 53.9 51.6 49.5 52.1 52.2 57.8 58.1 61.6 64.2 63.5 58.8 60.2 59.1 59.8 59.5 61.1 63.2 62.6 69.1 63.5 68.4 65.3
44.8 27.2 27.5 27.1 27.3 27.1 26.9 26.9 26.7 27.0 27.2 27.0 26.9 26.9 26.5 26.4 26.3 26.3 26.2 25.8 25.7 25.9 45.5 50.1 48.4 54.9 57.5 58.4 60.8 60.7 58.7 59.0 54.2 58.6 62.1 59.8 56.7 56.5 52.3 48.0 44.8 47.2 56.9 53.9 59.1 58.3 54.5 53.5 59.4 54.4 56.0 55.4 57.7 57.4 54.4 57.6 55.4 61.6
27.1 27.6 27.2 27.5 28.0 27.5 27.1 27.1 26.8 27.1 26.9 26.7 26.7 45.9 45.3 44.9 44.7 25.4 25.3 45.0 42.7 45.0 45.6 46.1 47.2 49.7 52.4 54.6 59.3 57.9 55.7 53.4 56.0 57.9 57.3 56.8 50.1 50.4 48.6 51.9 50.5 49.4 44.7 49.1 54.6 53.0 56.0 52.3 52.0 50.4 50.0 52.2 53.3 53.3 54.8 56.2 55.2 58.0
43.7 44.4 43.0 43.4 39.7 27.5 27.1 27.1 26.9 27.0 26.9 26.7 26.6 43.7 42.5 41.0 43.1 24.9 44.3 45.0 46.0 46.9 42.8 47.2 44.2 46.5 46.7 54.0 52.8 55.9 55.1 54.3 55.0 55.8 52.0 54.1 49.2 49.9 45.6 51.3 52.9 51.3 49.6 45.5 53.9 49.7 53.2 52.2 53.1 50.7 51.7 52.7 48.7 49.5 51.1 49.8 51.5 56.3
41.9 45.2 45.7 46.5 42.2 42.2 43.9 28.0 27.7 27.3 27.1 26.9 26.6 26.1 25.4 25.1 25.3 24.9 24.8 24.1 49.4 47.5 44.4 48.7 50.2 48.9 49.2 49.9 54.6 56.8 57.1 57.2 56.8 55.7 52.0 50.8 51.0 49.5 48.3 55.7 53.1 52.9 49.8 48.8 54.8 50.7 52.6 52.2 50.5 55.8 52.4 50.8 49.7 50.3 55.0 58.5 58.2 54.9
42.7 45.6 45.6 49.3 46.4 45.7 49.5 46.4 47.2 46.2 48.7 47.0 46.5 45.3 47.3 45.2 25.4 25.5 25.3 46.3 51.0 24.7 24.8 25.1 50.8 51.8 50.1 55.5 59.3 56.3 56.3 57.7 58.0 55.1 55.7 52.5 50.5 48.6 51.0 49.0 50.9 49.3 48.9 48.3 52.0 49.7 46.1 51.0 50.1 47.1 48.7 53.1 50.2 51.3 56.0 56.2 52.2 54.8
44.8 47.9 51.1 52.9 47.7 47.3 51.2 47.4 46.6 44.4 43.6 47.0 47.6 46.7 47.3 44.4 41.9 43.4 41.4 45.9 45.7 44.3 47.3 48.2 49.0 53.7 51.7 54.2 57.8 58.3 57.8 54.8 53.5 50.4 50.9 54.9 49.9 48.0 45.3 48.7 47.5 45.7 47.9 45.7 45.6 43.4 44.8 49.9 48.9 47.4 48.0 48.8 47.5 49.1 50.2 51.6 50.0 55.8
46.8 51.1 55.5 53.3 50.1 47.1 47.8 49.8 49.4 49.0 45.8 45.8 45.8 48.2 46.7 46.8 47.6 46.6 43.2 42.7 44.1 46.0 46.3 48.9 50.4 50.2 51.0 51.9 55.0 57.0 58.8 56.7 52.1 47.5 47.7 46.3 43.9 45.7 44.9 49.3 46.0 44.4 42.4 42.6 43.7 44.4 46.0 48.7 50.0 51.0 48.2 45.0 46.1 46.4 45.8 47.3 51.0 57.7
ASC
fi
OUT=${OUT:-$PWD}; WK=${WK:-$PWD/fig9_work}; export OUT WK
set -e
mkdir -p "$IN" "$OUT" "$WK"; cd "$WK"
W=27.85; E=30.45; S=40.45; N=41.65
REG=-R$W/$E/$S/$N
RES=0.000833333333
export GRASS_OVERWRITE=1 GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR
export GMT_DATA_SERVER=oceania

gmt grdcut @earth_relief_03s $REG -Gdem.nc
gmt grdconvert dem.nc dem.tif=gd:GTiff

GB=https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/main/releaseData/gbOpen/TUR/ADM1/geoBoundaries-TUR-ADM1.geojson
curl -sfL --max-time 150 -o tur.geojson "$GB"
ogr2ogr -f GeoJSON study.geojson tur.geojson -where "shapeName LIKE '%stanbul%' OR shapeName LIKE '%ocaeli%'"
ogr2ogr -f OGR_GMT study.gmt study.geojson

curl -sfL -o gaf.geojson https://raw.githubusercontent.com/cossatot/gem-global-active-faults/master/geojson/gem_active_faults.geojson
ogr2ogr -f GeoJSON gaf_aoi.geojson gaf.geojson -clipsrc 27.0 40.0 31.5 42.0
curl -sfL -o naf.gmt https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01/faults_nafz.gmt
ogr2ogr -f OGR_GMT gaf_aoi.gmt gaf_aoi.geojson
cat gaf_aoi.gmt naf.gmt > faults.gmt
ogr2ogr -f GeoJSON faults.geojson faults.gmt

CLC=/vsicurl/https://aquainfra-syke.a3s.fi/europe_clc_cog_raster/CLC2018ACC_V2018_20_cog.tif
gdalwarp -q -overwrite -t_srs EPSG:4326 -te $W $S $E $N -tr $RES $RES -r near "$CLC" clc.tif

python3 - "$IN/lith7_crop.b64" <<'PY'
import sys, gzip, base64, numpy as np, rasterio
from rasterio.transform import from_origin
t = gzip.decompress(base64.b64decode(open(sys.argv[1]).read())).decode().splitlines()
h = {l.split()[0]: float(l.split()[1]) for l in t[:5]}
a = np.array([[int(c) for c in r] for r in t[5:] if r], dtype="uint8")
tr = from_origin(h["xllcorner"], h["yllcorner"] + h["cellsize"] * a.shape[0], h["cellsize"], h["cellsize"])
with rasterio.open("lith7.tif", "w", driver="GTiff", height=a.shape[0], width=a.shape[1], count=1,
                   dtype="uint8", crs="EPSG:4326", transform=tr, nodata=0) as d: d.write(a, 1)
print("lith7 grid", a.shape)
PY
gdalwarp -q -overwrite -te $W $S $E $N -tr $RES $RES -r near lith7.tif lith_g.tif
gdal_translate -q -a_srs EPSG:4326 "$IN/chirps_rx1day_2015_2024.asc" rx1.tif
gdalwarp -q -overwrite -te $W $S $E $N -tr $RES $RES -r bilinear rx1.tif rx1_g.tif

rm -rf /tmp/gdb
grass -c EPSG:5254 /tmp/gdb/tm30 --exec bash -c '
set -e
r.import input=dem.tif output=dem resample=bilinear resolution=value resolution_value=100 extent=input --quiet
g.region raster=dem
r.slope.aspect -n elevation=dem slope=slope aspect=aspect pcurvature=pcurv --quiet
r.watershed -a elevation=dem accumulation=acc tci=twi threshold=100 stream=str --quiet
r.mapcalc "stri = if(isnull(str), 0, 1)" --quiet
r.neighbors input=stri output=strfrac method=average size=49 --quiet
r.mapcalc "dens = strfrac / 0.1" --quiet
v.import input=faults.geojson output=faults --quiet
v.to.rast input=faults output=fr use=val value=1 --quiet
r.grow.distance input=fr distance=fdist --quiet
for m in slope aspect pcurv twi dens fdist; do
  r.out.gdal -c -f input=$m output=${m}_tm.tif format=GTiff type=Float32 --quiet
done
'
for m in slope aspect pcurv twi dens fdist; do
  gdalwarp -q -overwrite -t_srs EPSG:4326 -te $W $S $E $N -tr $RES $RES -r bilinear ${m}_tm.tif ${m}_g.tif
done
gdalwarp -q -overwrite -te $W $S $E $N -tr $RES $RES -r bilinear dem.tif dem_g.tif
gmt grdgradient dem_g.tif -Nt0.9 -A315 -Gshade.nc

python3 - <<'PY'
import json, numpy as np, rasterio
from rasterio.features import rasterize
ref = rasterio.open("clc.tif"); prof = ref.profile; T = ref.transform; shp = (ref.height, ref.width)
rd = lambda f: rasterio.open(f).read(1, out_shape=shp).astype("float32")
geoms = [f["geometry"] for f in json.load(open("study.geojson"))["features"]]
mask = rasterize([(g, 1) for g in geoms], out_shape=shp, transform=T, fill=0, dtype="uint8").astype(bool)
dem = rd("dem.tif"); land = mask & (dem > 0)
def brk(a, edges, asc=True):
    o = np.full(a.shape, np.nan, "float32"); lo = -np.inf
    for i, hi in enumerate(list(edges) + [np.inf]):
        o[(a > lo) & (a <= hi)] = (i + 1) if asc else (5 - i); lo = hi
    return o
def quint(a, asc=True):
    v = a[land & np.isfinite(a)]; return brk(a, np.quantile(v, [.2, .4, .6, .8]), asc)
S = {}
slope = rd("slope_g.tif");  S["slope"] = brk(slope, [5, 15, 25, 35])
lith = rd("lith_g.tif").round()
lmap = {1: 4, 2: 3, 3: 2, 4: 3, 5: 4, 6: 1, 7: 3}
S["lith"] = np.full(shp, np.nan, "float32")
for k, v in lmap.items(): S["lith"][lith == k] = v
fd = rd("fdist_g.tif") / 1000.0;  S["fault"] = brk(fd, [1, 2, 3, 5], asc=False)
S["rain"] = quint(rd("rx1_g.tif"))
clc = rd("clc.tif").round(); lc = np.full(shp, np.nan, "float32")
for c in [111,112,121,122,123,124,131,132,133,141,142]: lc[clc == c] = 2
for c in [211,212,213,221,222,223,241,242,243,244]:     lc[clc == c] = 4
for c in [311,312,313]: lc[clc == c] = 1
for c in [231,321]:     lc[clc == c] = 3
for c in [322,323,324]: lc[clc == c] = 2
for c in [331,332,333,334]: lc[clc == c] = 5
S["lc"] = lc
S["twi"] = quint(rd("twi_g.tif"))
pc = rd("pcurv_g.tif"); sd = np.nanstd(pc[land]) or 1.0
S["curv"] = np.clip(np.rint(3 - 2 * np.tanh(pc / sd)), 1, 5).astype("float32")
S["dens"] = quint(rd("dens_g.tif"))
asp = rd("aspect_g.tif")
S["asp"] = np.where(np.isfinite(asp) & (asp >= 0), np.clip(np.rint(3 + 2 * np.cos(np.radians(asp))), 1, 5), 1).astype("float32")
prof.update(dtype="float32", nodata=np.nan, count=1, compress="deflate")
for k, a in S.items():
    a = a.astype("float32"); a[~land] = np.nan
    with rasterio.open(f"sc_{k}.tif", "w", **prof) as d: d.write(a, 1)
    v = a[np.isfinite(a)]; print(k, "classes:", {int(c): round(float((v == c).mean()) * 100, 1) for c in range(1, 6)})
PY

cat > score.cpt <<'EOF'
0.5	26/152/80	1.5	26/152/80	;Very low
1.5	166/217/106	2.5	166/217/106	;Low
2.5	254/224/139	3.5	254/224/139	;Moderate
3.5	253/174/97	4.5	253/174/97	;High
4.5	215/48/39	5.5	215/48/39	;Very high
EOF
gmt makecpt -Cgray -T-1.2/1.2 -G0.45/1 > base.cpt

gmt begin Figure_09 png,pdf E600
  gmt set FONT_ANNOT_PRIMARY 6.5p,Helvetica FONT_TAG 8p,Helvetica-Bold MAP_FRAME_TYPE plain \
          MAP_FRAME_PEN 0.6p MAP_TICK_LENGTH_PRIMARY 0.08c FORMAT_GEO_MAP ddd.xF \
          MAP_ANNOT_OFFSET_PRIMARY 0.08c PS_CHAR_ENCODING ISOLatin1+
  gmt subplot begin 3x3 -Fs5.5c/0 $REG -JM5.5c -M0.12c/0.22c -A+jTL+gwhite+o0.08c -SCb -SRl \
      -Bxa1f0.5 -Bya0.5f0.25 -BWSne
  k=0
  for pair in "slope:Slope angle" "lith:Lithology" "fault:Distance to faults" \
              "rain:Extreme rainfall" "lc:Land cover" "twi:Topographic wetness index" \
              "curv:Curvature" "dens:Drainage density" "asp:Aspect"; do
    key=${pair%%:*}; ttl=${pair#*:}; tag=$(printf "\\$(printf '%03o' $((65+k)))")
    gmt subplot set $k -A"$tag  $ttl"
    gmt grdimage shade.nc -Cbase.cpt
    gmt coast -Di -Slightsteelblue1 -A20
    gmt grdimage sc_$key.tif -Cscore.cpt -Ishade.nc -Q -nn
    gmt coast -Di -W0.25p,gray30 -A20
    gmt plot study.gmt -W0.7p,black
    gmt plot faults.gmt -W0.6p,red3
    k=$((k+1))
  done
  gmt subplot end
  gmt colorbar -Cscore.cpt -DJBC+w11c/0.3c+o0/0.55c+h -Li0.12c -R$W/$E/$S/$N -JM17.4c --FONT_ANNOT_PRIMARY=8p
gmt end
python3 - <<'PY'
from PIL import Image
im = Image.open("Figure_09.png").convert("RGB")
im.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).save("Figure_09_256c.png", optimize=True, dpi=(600, 600))
PY
cp Figure_09.png Figure_09_256c.png Figure_09.pdf "$OUT"/
