import json

VOLCANIC = {"Volcanic", "Volcanic-Hypabyssal", "Volcaniclastic", "Acid Volcanic-Hypabyssal",
            "Basic Volcanic-Hypabyssal", "Intermediate Volcanic-Hypabyssal",
            "Intermediate to basic Volcanic-Hypabyssal", "Hydrothermal",
            "Hydrothermal/Unconsolidated and Semiconsolidated"}
CAT = {"Q": 1, "N": 2, "P": 3, "K": 4, "J": 5, "Tr": 6, "Pz": 7, "V": 8, "G": 9}

def classify(props):
    lith = (props.get("Lith_Association") or "").strip(); a = (props.get("Age") or "").strip().lower()
    if lith in VOLCANIC: return "V"
    if "Intrusive" in lith: return "G"
    if lith == "Metamorphic": return "Pz"
    if lith in ("Ophiolite", "Ultrabasic"): return "J"
    if lith in ("Water", "Unmapped"): return None
    if any(k in a for k in ("quaternary", "holocene", "pleistocene")): return "Q"
    if any(k in a for k in ("neogene", "miocene", "pliocene")): return "N"
    if any(k in a for k in ("eocene", "oligocene", "paleocene")) or a == "tertiary": return "P"
    if "jurassic-cretaceous" in a or ("cretaceous" in a and "jurassic" not in a): return "K"
    if "jurassic" in a: return "J"
    if "triassic" in a or "permian-mesozoic" in a: return "Tr"
    if a == "mesozoic": return "K"
    if any(k in a for k in ("paleozoic", "permian", "carboniferous", "devonian", "silurian", "cambrian")): return "Pz"
    return None

if __name__ == "__main__":
    d = json.load(open("lithology_clip.geojson"))
    feats = [{"type": "Feature", "properties": {"catnum": CAT[c]}, "geometry": f["geometry"]}
             for f in d["features"] if (c := classify(f["properties"]))]
    json.dump({"type": "FeatureCollection", "features": feats}, open("lithology_classified.geojson", "w"))
