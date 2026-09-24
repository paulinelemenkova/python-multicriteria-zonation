import glob, numpy as np, rasterio

def mean_annual(pattern="y*.tif", out="precip_mean.tif"):
    prof, stack = None, []
    for f in sorted(glob.glob(pattern)):
        with rasterio.open(f) as src:
            arr = src.read(1).astype("float32")
            prof = prof or src.profile
            stack.append(np.where(arr == src.nodata, np.nan, arr))
    mean = np.nanmean(np.stack(stack, 0), 0)
    prof.update(dtype="float32", nodata=-9999.0, count=1)
    with rasterio.open(out, "w", **prof) as dst:
        dst.write(np.where(np.isnan(mean), -9999.0, mean), 1)
    return mean

if __name__ == "__main__":
    m = mean_annual(); print(f"range {np.nanmin(m):.0f}-{np.nanmax(m):.0f} mm/yr")
