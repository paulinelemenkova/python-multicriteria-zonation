#!/bin/bash
set -e

DATA_DIR="${1:?Usage: $0 <path to \"Geological map data of Turkey\" folder> [resolution_deg]}"
RES="${2:-0.0015}"
OUTDIR="$(pwd)/geology_output"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

LITH_TAB="$DATA_DIR/Turkey 500k Lithology V1.TAB"
FAULT_TAB="$DATA_DIR/Turkey 500k Faults V1.TAB"

if [ ! -f "$LITH_TAB" ]; then
  echo "ERROR: lithology file not found at: $LITH_TAB"
  echo "Check the path -- it should point to the folder containing the .TAB files directly."
  exit 1
fi

AOI="26.0 39.0 31.0 42.0"

echo "=== 1. Clip lithology to AOI ==="
ogr2ogr -f GeoJSON lithology_clip.geojson "$LITH_TAB" -clipsrc $AOI -t_srs EPSG:4326
python3 -c "import json; print('features:', len(json.load(open('lithology_clip.geojson'))['features']))"

echo "=== 2. Clip faults to AOI, convert to GMT multi-segment text ==="
ogr2ogr -f GeoJSON faults_clip.geojson "$FAULT_TAB" -clipsrc $AOI -t_srs EPSG:4326
python3 << 'PYEOF'
import json
d = json.load(open('faults_clip.geojson'))
lines = []
n_segs = 0
for f in d['features']:
    geom = f['geometry']
    coords_list = [geom['coordinates']] if geom['type'] == 'LineString' else geom['coordinates']
    for coords in coords_list:
        lines.append('>')
        n_segs += 1
        for lon, lat in coords:
            lines.append(f'{lon:.5f} {lat:.5f}')
open('faults_mta.gmt', 'w').write('\n'.join(lines))
print(f"faults_mta.gmt written: {n_segs} segments (full resolution, no simplification)")
PYEOF

echo "=== 3. Classify lithology polygons into 9 groups (Q/N/P/K/J/Tr/Pz/V/G) ==="
python3 << 'PYEOF'
import json
from collections import Counter

d = json.load(open('lithology_clip.geojson'))

def classify(props):
    lith = (props.get('Lith_Association') or '').strip()
    age = (props.get('Age') or '').strip()

    volcanic_liths = {
        'Volcanic', 'Volcanic-Hypabyssal', 'Volcaniclastic',
        'Acid Volcanic-Hypabyssal', 'Basic Volcanic-Hypabyssal',
        'Intermediate Volcanic-Hypabyssal', 'Intermediate to basic Volcanic-Hypabyssal',
        'Hydrothermal', 'Hydrothermal/Unconsolidated and Semiconsolidated'
    }
    if lith in volcanic_liths:
        return 'V'
    if 'Intrusive' in lith:
        return 'G'
    if lith == 'Metamorphic':
        return 'Pz'
    if lith in ('Ophiolite', 'Ultrabasic'):
        return 'J'
    if lith in ('Water', 'Unmapped'):
        return None

    a = age.lower()
    if any(k in a for k in ['quaternary', 'holocene', 'pleistocene']):
        return 'Q'
    if any(k in a for k in ['neogene', 'miocene', 'pliocene']):
        return 'N'
    if any(k in a for k in ['eocene', 'oligocene', 'paleocene']) or a == 'tertiary':
        return 'P'
    if 'jurassic-cretaceous' in a or (('cretaceous' in a) and ('jurassic' not in a)):
        return 'K'
    if 'jurassic' in a:
        return 'J'
    if 'triassic' in a:
        return 'Tr'
    if 'permian-mesozoic' in a:
        return 'Tr'
    if a == 'mesozoic':
        return 'K'
    if any(k in a for k in ['paleozoic', 'permian', 'carboniferous', 'devonian', 'silurian', 'cambrian']):
        return 'Pz'
    return None

cat_map = {'Q': 1, 'N': 2, 'P': 3, 'K': 4, 'J': 5, 'Tr': 6, 'Pz': 7, 'V': 8, 'G': 9}
cat_counts = Counter()
out_features = []
for f in d['features']:
    cat = classify(f['properties'])
    cat_counts[cat] += 1
    if cat is None:
        continue
    out_features.append({
        'type': 'Feature',
        'properties': {'catnum': cat_map[cat]},
        'geometry': f['geometry']
    })

print("category counts:")
for k, v in cat_counts.most_common():
    print(f"  {v:5d}  {k}")

json.dump({'type': 'FeatureCollection', 'features': out_features},
          open('lithology_catnum.geojson', 'w'))
print(f"classified features written: {len(out_features)}")
PYEOF

echo "=== 4. Rasterize at ${RES} deg resolution ==="
gdal_rasterize -a catnum -tr "$RES" "$RES" -te $AOI \
  -ot Byte -a_nodata 0 -init 0 \
  -co COMPRESS=DEFLATE -co PREDICTOR=2 \
  lithology_catnum.geojson lith.tif

gdalinfo lith.tif | grep -E "Size is"
echo ""
echo "=== Done ==="
echo "Output folder: $OUTDIR"
echo "  lith.tif        -- classified geology raster, ${RES} deg/pixel"
echo "  faults_mta.gmt  -- full-resolution MTA fault traces, GMT text format"
echo ""
echo "Next: run Figure_03_render_local.sh (needs GMT) pointing at this folder,"
echo "or open lith.tif in QGIS to sanity-check the classification visually"
echo "(values 1-9 = Q/N/P/K/J/Tr/Pz/V/G)."
