#!/usr/bin/env python3
"""Construit le paquet catalogue publié et, au besoin, celui embarqué dans l'app.

Usage :
  python3 tools/build_bundle.py                      # dist/catalog-<version>.json.gz + dist/latest.json
  python3 tools/build_bundle.py --app-asset          # met aussi à jour app/assets/catalog/
  python3 tools/build_bundle.py --version 202611230000
"""
import argparse
import shutil
import sys
from datetime import datetime, timezone

from catalog_lib import ROOT, bundle, default_version, load, validate, write_bundle


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", type=int, help="version AAAAMMJJHHMM (par défaut : maintenant, en UTC)")
    ap.add_argument("--out", default=str(ROOT / "dist"), help="dossier de sortie")
    ap.add_argument("--app-asset", action="store_true", help="copier aussi le paquet dans app/assets/catalog/")
    args = ap.parse_args()

    cat = validate(load())
    if cat.errors:
        for e in cat.errors:
            print(f"ERREUR : {e}")
        print("Paquet non construit : corrige les erreurs ci-dessus.")
        return 1

    now = datetime.now(timezone.utc)
    version = args.version or default_version(now)
    data = bundle(cat, version, now.replace(microsecond=0).isoformat().replace("+00:00", "Z"))
    out = ROOT / args.out if not args.out.startswith("/") else __import__("pathlib").Path(args.out)
    manifest = write_bundle(data, out)
    print(f"paquet {manifest['catalog']['file']} : {manifest['places']} lieux, "
          f"{manifest['catalog']['bytes']} octets, sha256 {manifest['catalog']['sha256'][:12]}…")

    if args.app_asset:
        dest = ROOT / "app/assets/catalog"
        dest.mkdir(parents=True, exist_ok=True)
        for old in dest.glob("catalog*.json.gz"):
            old.unlink()
        shutil.copy(out / manifest["catalog"]["file"], dest / "catalog.json.gz")
        print(f"copié dans {dest.relative_to(ROOT)}/catalog.json.gz")
    return 0


if __name__ == "__main__":
    sys.exit(main())
