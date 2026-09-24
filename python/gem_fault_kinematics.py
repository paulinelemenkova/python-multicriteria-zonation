import json

def split(geojson="gaf_aoi.geojson"):
    ss, nm, th = [], [], []
    for f in json.load(open(geojson))["features"]:
        st = f["properties"].get("slip_type") or ""
        g = f["geometry"]
        lines = g["coordinates"] if g["type"] == "MultiLineString" else [g["coordinates"]]
        if "Dextral" in st or "Sinistral" in st: bucket = ss
        elif st == "Normal": bucket = nm
        elif "Reverse" in st: bucket = th
        else: continue
        bucket.extend(lines)
    return ss, nm, th

def write_gmt(path, lines):
    with open(path, "w") as f:
        for line in lines:
            f.write(">\n" + "".join(f"{lon} {lat}\n" for lon, lat in line))

if __name__ == "__main__":
    for name, lines in zip(("strikeslip", "normal", "thrust"), split()):
        write_gmt(f"faults_{name}.gmt", lines); print(name, len(lines))
