# python-multicriteria-zonation

**Python workflow for multi-criteria landslide susceptibility zonation: AHP weighting, raster reclassification, weighted linear combination and quantile classification, coupled with GRASS GIS, GDAL and GMT.**

## Algorithms

- **Analytic Hierarchy Process (AHP):** priority vector from the principal eigenvector of a Saaty pairwise-comparison matrix; λmax, consistency index and consistency ratio; renormalisation of weights for factor subsets.
- **Extreme-precipitation index (Rx1day):** parallel, windowed HTTP reads of daily Cloud-Optimised GeoTIFFs; annual maxima and multi-year mean.
- **Rule-based vector classification:** lithological polygons by rock type and age; fault traces by kinematics.
- **Ordinal raster reclassification:** fixed class breaks, masked quintiles, look-up tables, and continuous transforms (tanh-scaled curvature, cosine-scaled aspect) to a common 1–5 scale.
- **Terrain and hydrology:** slope, aspect, profile curvature, flow accumulation, topographic wetness index, stream extraction, moving-window drainage density and Euclidean distance (GRASS GIS).
- **Weighted linear combination (WLC)** of the reclassified factors into a susceptibility index.
- **Pooled quantile classification:** one set of percentile breaks applied across administrative units, so that class areas are directly comparable.

## Overview

The workflow computes landslide susceptibility with the Analytic Hierarchy Process (AHP) and a weighted linear combination of conditioning factors, built entirely from public geospatial data and free and open-source software. It follows a multi-software approach:

| Task | Tool |
|---|---|
| AHP weights, reclassification, weighted overlay, classification, rainfall indices | Python 3 (NumPy, rasterio) |
| Slope, aspect, curvature, flow accumulation, TWI, drainage density, distance to faults | GRASS GIS 8 |
| Reprojection, resampling, format conversion | GDAL/OGR |
| Maps | Generic Mapping Tools (GMT 6), command line |

Each figure is produced by one Bash script that runs the whole chain from the raw data to the final map; the Python algorithms are embedded in these scripts and are also provided as standalone modules in `python/`.

## Repository structure

```
scripts/
  Figure_01.sh                          Study-area location map
  Figure_02.sh                          Topography (SRTM 3 arc-sec)
  Figure_03.sh                          Geology (MTA 1:500,000), nine age groups
  Figure_03_prepare_geology_local.sh    Optional: classify/rasterise the MTA vector map locally
  Figure_03_render_local.sh             Optional: render Figure 3 from the local rasterisation
  Figure_04.sh                          Tectonic elements and rock-type groups
  Figure_05.sh                          Mean annual precipitation 2015–2024 (CHIRPS v2.0)
  Figure_06.sh                          Land cover (CORINE Land Cover 2018)
  Figure_07.sh                          Slope angle
  Figure_08.sh                          Slope aspect
  Figure_09.sh                          Nine conditioning factors reclassified to scores 1–5
  Figure_10.sh                          Landslide susceptibility (AHP weighted overlay)
  lith7.b64.txt                         Seven-class lithology grid used by Figure_10.sh
python/
  ahp_weights.py                        AHP priority vector, λmax, CI, CR; weight renormalisation
  chirps_rx1day.py                      CHIRPS daily grids -> mean annual Rx1day 2015–2024
  chirps_mean_annual.py                 CHIRPS annual grids -> 2015–2024 mean
  mta_lithology.py                      MTA polygons -> nine age/rock groups
  gem_fault_kinematics.py               GEM faults -> strike-slip / normal / thrust
  factor_scoring.py                     Province mask and 1–5 scoring of the nine factors
  susceptibility_wlc.py                 Weighted linear combination and quantile classes
```

## Requirements

- GMT ≥ 6.4, GRASS GIS ≥ 8.2, GDAL/OGR ≥ 3.4, curl, ghostscript
- Python ≥ 3.9 with `numpy`, `rasterio`, `Pillow` (see `requirements.txt`)
- Internet access (the scripts download SRTM, CHIRPS, CORINE, GEM faults and geoBoundaries on the fly)

A conda environment with everything is defined in `environment.yml`:

```bash
conda env create -f environment.yml
conda activate python-multicriteria-zonation
```

## Usage

Run each script from an empty working directory:

```bash
mkdir run && cd run
bash ../scripts/Figure_09.sh            # writes Figure_09.png / .pdf
cp ../scripts/lith7.b64.txt . && bash ../scripts/Figure_10.sh
```

Reproduce the AHP weights and consistency ratio (Tables 2–3 of the article):

```bash
python python/ahp_weights.py
# lambda_max=9.377  CI=0.0472  CR=0.0325
```

## Data sources

| Data | Provider |
|---|---|
| SRTM 3 arc-sec / SRTM15+ relief | GMT remote data server (`earth_relief_03s`, `earth_relief_15s`) |
| Geology 1:500,000 | MTA (1961), digital version by Orr and Associates (2002) |
| Active faults | GEM Global Active Faults Database; NAF active trace after Emre et al. (2018) |
| Land cover | CORINE Land Cover 2018, Copernicus Land Monitoring Service (EEA) |
| Precipitation | CHIRPS v2.0, Climate Hazards Center, UC Santa Barbara |
| Administrative boundaries | geoBoundaries (TUR ADM1) |

Third-party data remain under the licences of their providers.

## Case study and citation

The workflow was developed and applied in: Lemenkova P. & Zülfikar A.C., *Python-based landslide susceptibility zonation of Istanbul and Kocaeli along the North Anatolian Fault Zone (Türkiye)*. The scripts in `scripts/` reproduce Figs. 1–10 of that article; the study-area extents are set as parameters at the top of each script and can be changed for any other region.

If you use this code, please cite the article and the archived software (see `CITATION.cff`).

## Licence

Code: MIT Licence (see `LICENSE`).
