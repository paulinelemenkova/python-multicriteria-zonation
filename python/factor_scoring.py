import json, numpy as np, rasterio
from rasterio.features import rasterize

CORINE_SCORE = {**{c: 2 for c in (111, 112, 121, 122, 123, 124, 131, 132, 133, 141, 142)},
                **{c: 4 for c in (211, 212, 213, 221, 222, 223, 241, 242, 243, 244)},
                311: 1, 312: 1, 313: 1, 231: 3, 321: 3,
                322: 2, 323: 2, 324: 2, 331: 5, 332: 5, 333: 5, 334: 5}
LITH_SCORE = {1: 4, 2: 3, 3: 2, 4: 3, 5: 4, 6: 1, 7: 3}

def province_mask(geojson, shape, transform):
    geoms = [f["geometry"] for f in json.load(open(geojson))["features"]]
    return rasterize([(g, 1) for g in geoms], out_shape=shape, transform=transform, fill=0).astype(bool)

def by_breaks(a, edges, ascending=True):
    out = np.full(a.shape, np.nan, "float32"); lo = -np.inf
    for i, hi in enumerate(list(edges) + [np.inf]):
        out[(a > lo) & (a <= hi)] = (i + 1) if ascending else (5 - i); lo = hi
    return out

def by_quintiles(a, mask, ascending=True):
    return by_breaks(a, np.quantile(a[mask & np.isfinite(a)], [.2, .4, .6, .8]), ascending)

def by_lookup(codes, table):
    out = np.full(codes.shape, np.nan, "float32")
    for k, v in table.items(): out[codes == k] = v
    return out

def curvature_score(pc, mask):
    sd = np.nanstd(pc[mask]) or 1.0
    return np.clip(np.rint(3 - 2 * np.tanh(pc / sd)), 1, 5)

def aspect_score(azimuth):
    return np.where(azimuth >= 0, np.clip(np.rint(3 + 2 * np.cos(np.radians(azimuth))), 1, 5), 1)

def score_all(rd, mask):
    return {"slope": by_breaks(rd("slope"), [5, 15, 25, 35]),
            "lith": by_lookup(np.rint(rd("lith")), LITH_SCORE),
            "fault": by_breaks(rd("fdist") / 1000.0, [1, 2, 3, 5], ascending=False),
            "rain": by_quintiles(rd("rx1day"), mask),
            "lc": by_lookup(np.rint(rd("clc")), CORINE_SCORE),
            "twi": by_quintiles(rd("twi"), mask),
            "curv": curvature_score(rd("pcurv"), mask),
            "dens": by_quintiles(rd("dens"), mask),
            "asp": aspect_score(rd("aspect"))}
