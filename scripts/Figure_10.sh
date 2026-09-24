#!/usr/bin/env bash
set -e
REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdsample dem_native.nc -Gdem_work.nc -I0.004 $REG
gmt grdsample dem_native.nc -Gdem_fine.nc -I0.0015 $REG
gmt grdgradient dem_fine.nc -Nt1 -A315/45 -Gshade.nc
gmt grdconvert dem_work.nc dem_work.tif=gd:GTiff

curl -sfL -o gaf.geojson \
  "https://raw.githubusercontent.com/cossatot/gem-global-active-faults/master/geojson/gem_active_faults.geojson"
ogr2ogr -f GeoJSON gaf_aoi.geojson gaf.geojson -clipsrc 26.0 39.0 31.0 42.0
curl -sfL -o faults_nafz.gmt \
  "https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01/faults_nafz.gmt"
ogr2ogr -f OGR_GMT gaf_aoi.gmt gaf_aoi.geojson
cat gaf_aoi.gmt faults_nafz.gmt > allfaults.gmt
gdal_rasterize -burn 1 -te 26.0 39.0 31.0 42.0 -tr 0.004 0.004 -ot Byte \
  -a_nodata 0 -init 0 allfaults.gmt faultrast.tif

grass --tmp-project EPSG:4326 --exec bash -c '
  set -e
  r.in.gdal input=dem_work.tif output=dem --overwrite
  g.region raster=dem
  r.slope.aspect elevation=dem slope=slope aspect=aspect pcurvature=pcurv format=degrees --overwrite
  r.in.gdal input=faultrast.tif output=fr --overwrite
  g.region raster=dem
  r.mapcalc "fp = if(fr==1,1,null())" --overwrite
  r.grow.distance input=fp distance=dist --overwrite
  r.out.gdal input=slope  output=slope.tif      type=Float32 --overwrite -f -c
  r.out.gdal input=aspect output=aspect.tif     type=Float32 --overwrite -f -c
  r.out.gdal input=pcurv  output=pcurv.tif      type=Float32 --overwrite -f -c
  r.out.gdal input=dist   output=dist2fault.tif type=Float32 --overwrite -f -c
'
read RX RY < <(python3 -c "import rasterio;s=rasterio.open('slope.tif');print(s.width,s.height)")

gdalwarp -overwrite -t_srs EPSG:4326 -te 26.0 39.0 31.0 42.0 -ts $RX $RY -r near \
  "/vsicurl/https://aquainfra-syke.a3s.fi/europe_clc_cog_raster/CLC2018ACC_V2018_20_cog.tif" clc_aoi.tif
python3 - <<'PYLC'
import rasterio, numpy as np
with rasterio.open('clc_aoi.tif') as src: arr=src.read(1); prof=src.profile
m={}
for c in [111,112,121,122,123,124,131,132,133,141,142]: m[c]=2
for c in [211,212,213,221,222,223,241,242,243,244]:     m[c]=4
m[311]=1; m[312]=1; m[313]=1
for c in [231,321]: m[c]=3
for c in [322,323,324]: m[c]=2
for c in [331,332,333,334]: m[c]=5
for c in [521,522,523,411,421,422,511,512]: m[c]=0
out=np.zeros(arr.shape,dtype=np.uint8)
for k,v in m.items(): out[arr==k]=v
prof.update(dtype=rasterio.uint8,nodata=0,count=1)
with rasterio.open('lc_susc.tif','w',**prof) as d: d.write(out,1)
PYLC

base64 -d lith7.b64.txt | zcat > lith7_src.tif 2>/dev/null || {
  echo "lith7.b64.txt not found next to this script -- see the delivered .png";
  exit 1; }
gdalwarp -overwrite -r near -te 26.0 39.0 31.0 42.0 -ts $RX $RY lith7_src.tif lith7.tif

python3 - <<'PYEOF'
import rasterio, numpy as np
rd=lambda fn: rasterio.open(fn).read(1).astype(float)
slope=rd('slope.tif'); aspect=rd('aspect.tif'); pcurv=rd('pcurv.tif')
dist=rd('dist2fault.tif'); lc=rd('lc_susc.tif'); lith=rd('lith7.tif')
shp=slope.shape
slope_s=np.select([slope<5,slope<15,slope<25,slope<35,slope>=35],[1,2,3,4,5],default=1)
aspect_s=np.clip(3+2*np.cos(np.deg2rad(aspect)),1,5)
sc=np.nanstd(pcurv) or 1
curv_s=np.clip(3-2*np.tanh(pcurv/(sc+1e-9)),1,5)
dist_s=np.select([dist<0.01,dist<0.02,dist<0.03,dist<0.05,dist>=0.05],[5,4,3,2,1],default=1)
lc_s=lc.copy()
lithmap={1:4,2:3,3:2,4:3,5:4,6:1,7:3}
lith_s=np.zeros(shp)
for k,v in lithmap.items(): lith_s[lith==k]=v
valid=(lith>0)&(lc>0)
W=dict(slope=0.3698,lith=0.2548,fault=0.1943,lc=0.1056,curv=0.0499,asp=0.0257)
num=(slope_s*W['slope']+lith_s*W['lith']+dist_s*W['fault']
     +lc_s*W['lc']+curv_s*W['curv']+aspect_s*W['asp'])
res=np.where(valid,num/sum(W.values()),np.nan)
q=np.percentile(res[valid & np.isfinite(res)],[20,40,60,80])
cls=np.zeros(shp,dtype=np.uint8)
cls[valid&(res<q[0])]=1
cls[valid&(res>=q[0])&(res<q[1])]=2
cls[valid&(res>=q[1])&(res<q[2])]=3
cls[valid&(res>=q[2])&(res<q[3])]=4
cls[valid&(res>=q[3])]=5
prof=rasterio.open('slope.tif').profile
prof.update(dtype=rasterio.uint8,nodata=0,count=1)
with rasterio.open('susc.tif','w',**prof) as d: d.write(cls,1)
PYEOF

gmt grdconvert susc.tif susc_raw.nc=nf
gmt grdsample susc_raw.nc -Gsusc_f0.nc -Rdem_fine.nc -nn
gmt grdmath susc_f0.nc 0 NAN = susc_fine.nc

cat > cities.txt <<'EOCT'
26.5557 41.6771 R Edirne
27.5167 40.9833 R Tekirdag
28.9784 41.0082 L Istanbul
26.4142 40.1553 L Canakkale
27.9773 40.3524 L Bandirma
29.0665 40.1826 L Bursa
29.9208 40.7654 L Izmit
30.3781 40.7569 L Sakarya
EOCT
cat > lakes.txt <<'EOLK'
30.25 40.715 Sapanca L.
29.52 40.43 Iznik L.
27.75 40.18 Manyas L.
EOLK
curl -sfL -o tur.geojson \
  "https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/main/releaseData/gbOpen/TUR/ADM1/geoBoundaries-TUR-ADM1.geojson"
ogr2ogr -f OGR_GMT provinces.gmt tur.geojson -clipsrc 26.0 39.0 31.0 42.0 2>/dev/null

cat > susc.cpt <<'EOCPT'
0.5	46/110/140	1.5	46/110/140
1.5	140/190/90	2.5	140/190/90
2.5	250/230/70	3.5	250/230/70
3.5	240/150/40	4.5	240/150/40
4.5	200/30/30	5.5	200/30/30
N	gray85
EOCPT

gmt begin Figure_10 pdf E300
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -G30/80/140 -L
  gmt grdimage susc_fine.nc -Csusc.cpt -Ishade.nc -Q
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-
  gmt plot allfaults.gmt -W0.6p,60/60/60@40
  gmt basemap -Bxg1 -Byg0.5
  echo "29.6 41.8 Black Sea" | gmt text -F+f12p,Helvetica-Bold,white+jCM
  echo "28.0 40.75 Sea of Marmara" | gmt text -F+f11p,Helvetica-Oblique,white+jLM
  awk '{print $1,$2,$3,$4}' lakes.txt | gmt text -F+f7.5p,Helvetica-Oblique,26/63/102+jCM -Gwhite@30
  while read lon lat just name; do
    echo "$lon $lat" | gmt plot -Sc0.16c -Gwhite -W0.7p,black
    if [ "$just" = "R" ]; then jc="BR"; dx="-0.15c/0.08c"; else jc="BL"; dx="0.15c/0.08c"; fi
    echo "$lon $lat $name" | gmt text -F+f9p,Helvetica-Bold,black+j${jc} -Gwhite@20 -C1p/1p -D${dx}
  done < cities.txt
  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p
  gmt legend -Dx0/-0.5c+w18c+jTL -F+gwhite+p0.5p,gray70 <<EOLG
N 3
H 10p,Helvetica-Bold LANDSLIDE SUSCEPTIBILITY
S 0.3c s 0.34c 200/30/30 0.3p 0.7c Very High
S 0.3c s 0.34c 240/150/40 0.3p 0.7c High
S 0.3c s 0.34c 250/230/70 0.3p 0.7c Moderate
S 0.3c s 0.34c 140/190/90 0.3p 0.7c Low
S 0.3c s 0.34c 46/110/140 0.3p 0.7c Very Low
EOLG
  gmt text -R0/1/0/1 -JX18c/1.4c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-3.1c <<EOCR
0.005 0.9 AHP-weighted overlay of 6 conditioning factors: slope (0.37), lithology (0.25), distance-to-fault (0.19), land cover (0.11), curvature (0.05),
0.005 0.5 aspect (0.03) -- weights renormalized from the project's AHP after dropping rainfall/TWI/drainage. Data: SRTM 3-arcsec (slope/aspect/curvature via
0.005 0.1 GRASS r.slope.aspect), GEM Active Faults + NAF (distance via r.grow.distance), CORINE 2018 land cover, MTA 1961 lithology. Classes: quantile breaks.
EOCR
gmt end
echo "Wrote Figure_10.pdf"
