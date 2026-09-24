import sys, datetime as dt, numpy as np, rasterio
from rasterio.windows import from_bounds
from concurrent.futures import ThreadPoolExecutor

W, S, E, N = 27.8, 40.3, 30.7, 41.7
URL = ("https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_daily/cogs/p05/"
       "{y}/chirps-v2.0.{y}.{m:02d}.{d:02d}.cog")

def read_day(day):
    with rasterio.open("/vsicurl/" + URL.format(y=day.year, m=day.month, d=day.day)) as src:
        win = from_bounds(W, S, E, N, src.transform).round_offsets().round_lengths()
        a = src.read(1, window=win).astype("float32"); a[a < 0] = np.nan
        return day, a, src.window_transform(win)

def rx1day(first=dt.date(2015, 1, 1), last=dt.date(2024, 12, 31), threads=64):
    days = [first + dt.timedelta(i) for i in range((last - first).days + 1)]
    with ThreadPoolExecutor(threads) as ex:
        res = list(ex.map(read_day, days))
    annual_max = {}
    for day, a, _ in res:
        annual_max[day.year] = np.fmax(annual_max.get(day.year, np.full(a.shape, np.nan)), a)
    return np.nanmean(np.stack(list(annual_max.values())), 0), res[0][2]

def write_asc(grid, tr, path):
    ny, nx = grid.shape
    with open(path, "w") as f:
        f.write(f"ncols {nx}\nnrows {ny}\nxllcorner {tr.c:.4f}\nyllcorner {tr.f + tr.e * ny:.4f}\n"
                f"cellsize {tr.a:.4f}\nNODATA_value -9999\n")
        for row in np.where(np.isnan(grid), -9999, grid):
            f.write(" ".join(f"{v:.1f}" for v in row) + "\n")

if __name__ == "__main__":
    grid, tr = rx1day()
    write_asc(grid, tr, sys.argv[1] if len(sys.argv) > 1 else "chirps_rx1day_2015_2024.asc")
