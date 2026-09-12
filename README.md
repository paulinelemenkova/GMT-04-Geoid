# GMT Geoid — Gravitational Geoid Undulation Mapping Scripts

A collection of GMT (Generic Mapping Tools) shell scripts for mapping the Earth's geoid, the equipotential surface of the gravity field, from global Earth Gravitational Models. Geoid undulation grids are colour-shaded and contoured over countries, seas and ocean trenches. The scripts have been used to generate map figures across the author's geophysical, geodetic and cartographic publications.

## What the scripts do

Each script builds a complete geoid map, typically chaining:

- colour palette generation from the grid (grd2cpt / makecpt)
- geoid grid rendering with illumination (grdimage)
- geoid undulation contours in metres (grdcontour)
- coastlines and frames (pscoast)
- colour scale bars (psscale), grids, titles, scale bars (psbasemap)
- directional and magnetic roses (psbasemap -T)
- a global geoid locator image / inset (psimage)
- annotations, subtitles and labels (pstext)
- export to raster (psconvert) at high resolution

Map projections are chosen per region (equidistant conic, Mercator, Eckert VI for the world inset, etc.).

## Data sources

Global Earth Gravitational Models: EGM2008 and EGM96 geoid grids (geoid undulation relative to the reference ellipsoid). Coastlines from GSHHG via GMT.

## File naming

Scripts follow GMT-04-...-geoid-XX.sh, where XX is an ISO country code or a feature tag: countries (e.g. TZ = Tanzania, VE = Venezuela, IR = Iran), ocean trenches (e.g. KKT = Kuril-Kamchatka Trench, MAT = Middle America Trench, PSB = Philippine Sea Basin) and seas. Variants encode the gravity model used, e.g. -EGM2008 or -EGM96.

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash/sh)
- The relevant EGM geoid grid(s) (EGM2008 / EGM96) available locally

## Usage

Place the required geoid grid in the working directory, adjust the -R region and -J projection at the top of the chosen script, then run:

    bash GMT-04-script-JD-geoid-KKT.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's geophysical, geodetic and cartographic papers; please cite the specific article a given map appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
