#!/usr/bin/env python3
"""Découpe les cartes hors ligne dans un build Protomaps (OpenStreetMap).

Lit catalog/map_packs.json, télécharge par requêtes partielles (HTTP Range)
les seules tuiles de chaque région, et écrit un fichier PMTiles par paquet.
Avec --mbtiles, écrit aussi la même carte au format MBTiles (pour comparer
les deux lecteurs de tuiles pendant la phase 0).

Usage :
  python3 tools/extract_maps.py                       # tous les paquets, dernier build
  python3 tools/extract_maps.py --only guangzhou --mbtiles
  python3 tools/extract_maps.py --app-assets          # copie les paquets embarqués dans app/assets/maps/

Les fichiers produits ne sont pas versionnés (trop lourds) : la CI les
régénère pour chaque release. Données © contributeurs OpenStreetMap (ODbL).
"""
from __future__ import annotations

import argparse
import json
import math
import shutil
import sys
import threading
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from pmtiles.convert import pmtiles_to_mbtiles
from pmtiles.reader import Reader
from pmtiles.tile import Compression, TileType, zxy_to_tileid
from pmtiles.writer import Writer

ROOT = Path(__file__).resolve().parent.parent
BUILDS = "https://build-metadata.protomaps.dev/builds.json"
BUILD_URL = "https://build.protomaps.com/{key}"
USER_AGENT = "bs-road-map-extract/1.0 (+https://github.com/syrax68/bs-road)"


def latest_build() -> str:
    with urllib.request.urlopen(urllib.request.Request(BUILDS, headers={"User-Agent": USER_AGENT}), timeout=30) as r:
        builds = json.load(r)
    return BUILD_URL.format(key=builds[-1]["key"])


class RangeSource:
    """Lecture par plages d'octets, avec cache des répertoires (petits blocs)."""

    def __init__(self, url: str):
        self.url = url
        self.cache: dict[tuple[int, int], bytes] = {}
        self.lock = threading.Lock()

    def __call__(self, offset: int, length: int) -> bytes:
        key = (offset, length)
        with self.lock:
            if key in self.cache:
                return self.cache[key]
        for attempt in range(5):
            try:
                req = urllib.request.Request(
                    self.url,
                    headers={"Range": f"bytes={offset}-{offset + length - 1}", "User-Agent": USER_AGENT},
                )
                with urllib.request.urlopen(req, timeout=60) as r:
                    data = r.read()
                if len(data) == length:
                    break
            except OSError:
                pass
            time.sleep(1 + attempt)
        else:
            raise RuntimeError(f"plage {offset}+{length} illisible")
        if length < 2_000_000:
            with self.lock:
                self.cache[key] = data
        return data


def tile_x(lon: float, z: int) -> int:
    return int((lon + 180) / 360 * (1 << z))


def tile_y(lat: float, z: int) -> int:
    r = math.radians(lat)
    return int((1 - math.asinh(math.tan(r)) / math.pi) / 2 * (1 << z))


def tiles_for(bbox: list[float], min_zoom: int, max_zoom: int) -> list[tuple[int, int, int]]:
    west, south, east, north = bbox
    out = []
    for z in range(min_zoom, max_zoom + 1):
        for x in range(tile_x(west, z), tile_x(east, z) + 1):
            for y in range(tile_y(north, z), tile_y(south, z) + 1):
                out.append((z, x, y))
    return out


def extract(reader: Reader, pack: dict, out: Path, workers: int) -> dict:
    wanted = tiles_for(pack["bbox"], pack["minZoom"], pack["maxZoom"])
    t0 = time.time()
    with ThreadPoolExecutor(workers) as ex:
        data = list(ex.map(lambda t: (t, reader.get(*t)), wanted))
    found = sorted(((zxy_to_tileid(*t), d) for t, d in data if d), key=lambda e: e[0])

    west, south, east, north = pack["bbox"]
    src = reader.header()
    header = {
        "tile_type": TileType.MVT,
        "tile_compression": Compression(src["tile_compression"].value if hasattr(src["tile_compression"], "value") else src["tile_compression"]),
        "min_lon_e7": int(west * 1e7),
        "min_lat_e7": int(south * 1e7),
        "max_lon_e7": int(east * 1e7),
        "max_lat_e7": int(north * 1e7),
        "center_zoom": pack["maxZoom"] - 3 if pack["maxZoom"] > 10 else pack["minZoom"] + 3,
        "center_lon_e7": int((west + east) / 2 * 1e7),
        "center_lat_e7": int((south + north) / 2 * 1e7),
    }
    metadata = reader.metadata()
    metadata.update({
        "name": pack["name"],
        "attribution": "© OpenStreetMap contributors",
        "bs_road_pack": pack["id"],
    })
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "wb") as f:
        w = Writer(f)
        for tid, d in found:
            w.write_tile(tid, d)
        w.finalize(header, metadata)
    return {
        "id": pack["id"],
        "tiles": len(found),
        "bytes": out.stat().st_size,
        "seconds": round(time.time() - t0),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", help="URL d'un fichier .pmtiles (par défaut : dernier build Protomaps)")
    ap.add_argument("--only", nargs="*", help="identifiants des paquets à produire")
    ap.add_argument("--out", default=str(ROOT / "dist/maps"))
    ap.add_argument("--mbtiles", action="store_true", help="écrire aussi une version MBTiles")
    ap.add_argument("--app-assets", action="store_true", help="copier les paquets embarqués dans app/assets/maps/")
    ap.add_argument("--workers", type=int, default=6)
    args = ap.parse_args()

    packs = json.loads((ROOT / "catalog/map_packs.json").read_text(encoding="utf-8"))["packs"]
    if args.only:
        packs = [p for p in packs if p["id"] in args.only]
    source = args.source or latest_build()
    print(f"source : {source}")
    reader = Reader(RangeSource(source))
    out_dir = Path(args.out)

    report = []
    for pack in packs:
        dest = out_dir / f"{pack['id']}.pmtiles"
        r = extract(reader, pack, dest, args.workers)
        if args.mbtiles:
            mb = dest.with_suffix(".mbtiles")
            mb.unlink(missing_ok=True)
            pmtiles_to_mbtiles(str(dest), str(mb))
            r["mbtilesBytes"] = mb.stat().st_size
        report.append(r)
        print(f"{pack['id']} : {r['tiles']} tuiles, {r['bytes'] / 1e6:.1f} Mo en PMTiles"
              + (f", {r['mbtilesBytes'] / 1e6:.1f} Mo en MBTiles" if "mbtilesBytes" in r else "")
              + f" ({r['seconds']} s)")
        if args.app_assets and pack.get("embedded"):
            assets = ROOT / "app/assets/maps"
            assets.mkdir(parents=True, exist_ok=True)
            for ext in (".pmtiles", ".mbtiles"):
                f = dest.with_suffix(ext)
                if f.exists():
                    shutil.copy(f, assets / f.name)
    (out_dir / "maps.json").write_text(json.dumps({"source": source, "packs": report}, indent=2) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
