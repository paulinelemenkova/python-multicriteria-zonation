#!/bin/bash

set -e
REG="-R26.0/31.0/39.0/42.0"
export GMT_DATA_SERVER=oceania GMT_AUTO_DOWNLOAD=on
gmt set GMT_AUTO_DOWNLOAD on GMT_DATA_SERVER oceania >/dev/null 2>&1 || true

cat > lith7.b64 << 'B64EOF'
H4sICHMOtGoAA2xpdGg3LnRpZgDtnb3Lfc920M/MnH3mikESNKZQMWInKSxSSBqvhYSAXQS1srGMIGIhKoIauFapRKysglXQpLLy
vxALsRHE6pZa2Xj2zHpfa2bPPi/P8/19f8+69/d99tkvs2fWZ9aa99m/9Vt/6fKTy+XyS5dLKpd0P/o/938SHP/a/Z8Mx/tdBY73
/27i+JfS9fInL/3HL4vzfxqOf/H+36/cj/d7/vv9vz8r7vltcfwn/tUvXMr979+4//iXv/sLl9v9+O/dj//Tz8rlV+/H/+Z+/Ic/
+4VLvh//1/vxH/0st3j9r/vxv/j93M7/5UuXn/754//9g1/5+f3JX/sLl8vv/PRy+YO/e7n8/J/ff//7++//cv/9P+6//9/9959J
l9/5jXT5g7+TLj//x+nya//u/vs/33//t/vv/3v//cv58ju/ni//9E/9x9/8n//kd/8q/r0syW/8tP/96z/FM6npol4u1/04X9IV
zv1k//u/fzH95I9+VncC7ffv/cU/9pM//Nl+/Y+3v5fLv/77/+jf/rnf/4d7eD/9D3/zb/+1v/Wbv/2rf+XX/9ladB6Q6zm54cGp
4Mvbov8l6wLQdiA53263mHDAnG5dfU9jXi6F5Y3J+hIhjZX8KTju0NcNvcmY+n51uwv8BORXAp7zF/QPkTsp8sr7oTbsvAycoOOR
esutAW/EN8IO0HfaO/Ad+Rf0DxDpkhW1h0RBv8m3gBNg7FRbKJ13/nLvHyMTaI8i5x/XG7/lZpF3aTfmLJl/qj5+BPIw3NU8AO+Q
2Wgz1DvwtDOvd+T1s3XyvYuy0HdA98gd9Y48gZ3XL+ZvF2L+DuIYrg8ceGNR3g29Vee+mL9d3oR6UYB5apbef39Bf7u8nyuWGqra
xgKuPe3/7RH6Yv5ueT9yyZ4kgt6Rf8nb5VyXy8uYS/JQnF++mH+M7NomxX8C9btksvPPVsaPQ7KRT4B+fylC/2xt/Cik15jTx2EP
mO+nv4rztwmDxR8pZcs8N8P7KOztVEL5bAV9f2LRYrs4OP9Wg3eVuITcP1tD35/EzNOI+dvQR+21a8f+2Sr63iRCvveEzJEL6i/L
AsORuy/mL5UBcWP0S/I+5l/QXyoh84eQA/Y31fQ+W0/fk4TMj8ryOffM0NMX9G9QDpkP8B/lCsM8rp19Qf8UiYE+zzxr5sj9C/o3
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
VpKzzhNeUY7rTALk++kgKlzPE/lFREM08U1cHiX+rXexn5KlLcAUmuDUCHqfEb3KPJp46phXLc6P9Nfi21VcHuX93TFfFKv7UX3c
KSsqIpYe3Z+yfTKWeHVlBwKmPPcMaCkfqu2PlBO5eUYOJpNkVfifQt6fqq2Lhl5omu+CeTdFCuSFqLv88EbMl8UZs5QMs1L43hhd
u02FuSRCw9cqGwjAfA8ym246y/ZdyL9f156GyPVub3DzoEoeBHqG+fVa5f5yu2BImYjqAn3E6ZXg36b0T5aI2a43YXTeJg14G6a/
Y8h8/++6Iy9yQpzQd8j8ZVSnTbn3K/9DhQ03dduF8/gZH9UVM2pCD+x9cjmSZuMZp8ORUIRIXs6c8/H2/RMXUw/4W0Wo2P1f0Qlz
pY+8xG3d63XPGaK6xgpdAh4iv143iKl52zO8kz7in+6bZumbn/t2Wrq6ex2ZdJlFccrArw654NJw73eJirrpo5XZwPLuH4tsQcuR
luu23ZEjczfJ/GHiiRaxth1LKbTNfe3oOyMOBIB4xr6rzHUfybtTRet2TaaihfKAVLLTu8gHV+moMRvdccfMJ8jTwS38TjyY9cmu
aXL/eHX7nPE3KLSThvK8+LlNsnOFG4lDcxnvCYhfr/IRUQcIu7qFTxerFyBs/Pj7znwbMI9JkR+ZQzQ9tU2sWz/w6lf456rlnfyW
pMddlIRYevk+UpyRlC1x5ifKT2fnVzZtI8PRDVWK25JCInfl+bGZu604rFji/iPES1796uR2eyG/0wJRr/1bS1otsdboLv6Qk/Tp
YIye927p7AyspHQbEkpXz1whHzIXY+IOuczlA+XMkafVmhuBFvISeI8JUGwioY+nfNp6MJbiceHtGQXM95Ppxl/zth/1dt3nMjQw
c/aXMXJXtZN+ZaSddNFunVpokBUWlXxz8jS3Z2R30Pc4sH0y8jUZABdbQlZNlw7V2WR9n8SeOmZLG5n3/7iMNKCT3vK4Mew3oosf
i6zQbIj8DO5diPSezPTJhXmbv9xiU4F7K7LrIvIO8AobPobIJW4sAURhQFUBYI5e43pDkwfm3bVfQ+ZXy/yC9VB5IoR7QFzllbsv
AeIPKRrd2OcS1wWMrSJRWuO9vojOlXb0PWJuHPt2//+2Qbg4OV6F3H+It9XI1MHM81uUKfI+IH+wt+1bAL7HoiD04oj33uwdVB1s
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
AWgG87OYGpMsOv7/IJZ6utxLAgA=
B64EOF
tr -d '\n' < lith7.b64 | base64 -d > lith7.tif.gz
MD5=$(md5sum lith7.tif.gz | cut -d' ' -f1)
EXPECTED_MD5="bbad5f7ff035d4e827742f8c15fc620f"
if [ "$MD5" != "$EXPECTED_MD5" ]; then
  echo "!!!! CHECKSUM MISMATCH (got $MD5, expected $EXPECTED_MD5) -- embedded"
  echo "!!!! data is corrupted, aborting before wasting time on rendering."
  exit 1
fi
gunzip -f lith7.tif.gz
echo "lithology-type raster OK: $MD5"

gmt grdcut @earth_relief_03s $REG -Gdem_native.nc=nf
gmt grdsample dem_native.nc -Gdem_fine.nc -I0.0015 $REG
gmt grdgradient dem_fine.nc -Nt1 -A315/45 -Gshade.nc
read -r NX NY <<< "$(gmt grdinfo -C dem_fine.nc | awk '{print $10, $11}')"

gdalwarp -overwrite -r near -te 26.0 39.0 31.0 42.0 -ts "$NX" "$NY" lith7.tif lith7_m.tif
gmt grdconvert lith7_m.tif lith7_raw.nc=nf
gmt grdsample lith7_raw.nc -Glith7_fine0.nc -Rdem_fine.nc -nn
gmt grdmath lith7_fine0.nc 0 NAN = lith7_fine.nc

GAF_URL="https://raw.githubusercontent.com/cossatot/gem-global-active-faults/master/geojson/gem_active_faults.geojson"
curl -sfL --max-time 120 -o gaf.geojson "$GAF_URL"
ogr2ogr -f GeoJSON gaf_aoi.geojson gaf.geojson -clipsrc 26.0 39.0 31.0 42.0

python3 << 'CLASSIFYPY'
import json
d = json.load(open('gaf_aoi.geojson'))
ss, nm, th = [], [], []
for f in d['features']:
    st = (f['properties'].get('slip_type') or '')
    geom = f['geometry']
    lines = geom['coordinates'] if geom['type'] == 'MultiLineString' else [geom['coordinates']]
    if 'Dextral' in st or 'Sinistral' in st:
        bucket = ss
    elif st == 'Normal':
        bucket = nm
    elif 'Reverse' in st:
        bucket = th
    else:
        continue
    for line in lines:
        bucket.append(line)

def write_gmt(fname, lines):
    with open(fname, 'w') as f:
        for line in lines:
            f.write(">\n")
            for lon, lat in line:
                f.write(f"{lon} {lat}\n")

write_gmt('faults_strikeslip.gmt', ss)
write_gmt('faults_normal.gmt', nm)
write_gmt('faults_thrust.gmt', th)
print('strike-slip segs:', len(ss), 'normal:', len(nm), 'thrust:', len(th))
CLASSIFYPY

curl -sfL --max-time 60 -o faults_nafz.gmt \
  "https://raw.githubusercontent.com/paulinelemenkova/coseismic-landslide-hazard-hsr/main/scripts/fig01/faults_nafz.gmt"

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

cat > lith7.cpt << 'EOCPT'
0.5\t255/245/180\t1.5\t255/245/180
1.5\t240/200/110\t2.5\t240/200/110
2.5\t200/170/120\t3.5\t200/170/120
3.5\t170/140/160\t4.5\t170/140/160
4.5\t60/130/75\t5.5\t60/130/75
5.5\t225/150/165\t6.5\t225/150/165
6.5\t200/90/60\t7.5\t200/90/60
N\tgray85
EOCPT

gmt begin Figure_04 pdf E300
  gmt set FONT_ANNOT_PRIMARY 9p,Helvetica FONT_LABEL 10p,Helvetica FONT_TITLE 13p,Helvetica \
          MAP_FRAME_TYPE plain MAP_FRAME_PEN 1p PS_CHAR_ENCODING Standard+ \
          FORMAT_GEO_MAP=ddd.xF MAP_ANNOT_OFFSET 3p MAP_TITLE_OFFSET 12p \
          MAP_GRID_PEN_PRIMARY 0.3p,white
  gmt basemap -JM18c $REG -Bxa1f0.5 -Bya0.5f0.25 -BWESN
  echo "26 39
31 39
31 42
26 42" | gmt plot -G30/80/140 -L
  gmt grdimage lith7_fine.nc -Clith7.cpt -Ishade.nc -Q
  gmt coast -Di -W0.5p,black -A5
  gmt plot provinces.gmt -W0.4p,black,-

  gmt plot faults_normal.gmt -W1p,30/90/170
  gmt plot faults_thrust.gmt -W1.3p,90/60/20
  gmt plot faults_strikeslip.gmt -W1p,150/20/20
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
  echo "27.15 40.44 Ganos Fault" | gmt text -F+f7p,Helvetica-Oblique,150/20/20+a-18+jCM -Gwhite@30
  echo "29.85 40.72 Izmit Fault" | gmt text -F+f7p,Helvetica-Oblique,150/20/20+a-5+jCM -Gwhite@30

  gmt basemap $REG -JM18c -LjBL+w50k+f+o0.6c/0.6c+c40.5 --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p

  gmt legend -Dx0/-0.4c+w18c+jTL -F+gwhite << EOLG
N 3
H 10p,Helvetica-Bold LEGEND
S 0.3c - 0.6c 180/0/0 2.2p 0.55c NAF (active)
S 0.3c - 0.6c 150/20/20 1p 0.55c Strike-slip
S 0.3c - 0.6c 30/90/170 1p 0.55c Normal
S 0.3c - 0.6c 90/60/20 1.3p 0.55c Thrust
S 0.3c s 0.32c 255/245/180 0.3p 0.55c Quaternary Basins
S 0.3c s 0.32c 240/200/110 0.3p 0.55c Neogene-Paleogene Basins
S 0.3c s 0.32c 200/170/120 0.3p 0.55c Meso-Paleozoic Sediments
S 0.3c s 0.32c 170/140/160 0.3p 0.55c Metamorphic Basement
S 0.3c s 0.32c 60/130/75 0.3p 0.55c Ophiolite/Ultrabasic
S 0.3c s 0.32c 225/150/165 0.3p 0.55c Granitic/Intrusive
S 0.3c s 0.32c 200/90/60 0.3p 0.55c Volcanic/Volcaniclastic
EOLG

  gmt text -R0/1/0/1 -JX18c/1.6c -F+f6p,Helvetica-Oblique,gray30+jTL -N -Y-5.0c << EOCR
0.005 0.9 Lithology-type: MTA 1:500,000 Geology Map of Turkey (1961), reclassified by rock type (not just age) into 7 groups
0.005 0.58 (ophiolite/ultrabasic marks likely suture-zone material). Faults: GEM Global Active Faults Database (kinematics) +
0.005 0.26 North Anatolian Fault active trace. Not a verified Istanbul-Zone vs Sakarya-Zone terrane boundary.
EOCR
gmt end

echo "Done: Figure_04.pdf and Figure_04.png written to $(pwd)"
