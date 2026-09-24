import numpy as np, rasterio

W6 = dict(slope=0.3698, lith=0.2548, fault=0.1943, lc=0.1056, curv=0.0499, asp=0.0257)

def lsi(scores, valid, weights=W6):
    num = sum(weights[k] * scores[k] for k in weights)
    return np.where(valid, num / sum(weights.values()), np.nan)

def quantile_classes(index, valid):
    q = np.percentile(index[valid & np.isfinite(index)], [20, 40, 60, 80])
    cls = np.zeros(index.shape, "uint8")
    cls[valid] = 1 + np.searchsorted(q, index[valid], side="right")
    return cls, q

if __name__ == "__main__":
    rd = lambda f: rasterio.open(f).read(1).astype(float)
    s = {k: rd(f"{k}_score.tif") for k in W6}
    valid = np.isfinite(s["lith"]) & np.isfinite(s["lc"]) & (s["lith"] > 0) & (s["lc"] > 0)
    cls, q = quantile_classes(lsi(s, valid), valid)
    prof = rasterio.open("slope_score.tif").profile; prof.update(dtype="uint8", nodata=0)
    with rasterio.open("susceptibility_classes.tif", "w", **prof) as d: d.write(cls, 1)
    print("class breaks:", np.round(q, 3))
