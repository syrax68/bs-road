#!/usr/bin/env python3
"""Contrôle le catalogue. Code de sortie 1 s'il y a une erreur.

Usage : python3 tools/validate.py
"""
import sys

from catalog_lib import load, validate


def main() -> int:
    cat = validate(load())
    for w in cat.warnings:
        print(f"avertissement : {w}")
    for e in cat.errors:
        print(f"ERREUR : {e}")
    print(f"{len(cat.places)} lieux, {len(cat.alerts)} signalements, "
          f"{len(cat.categories)} catégories, {len(cat.zones)} quartiers : "
          f"{len(cat.errors)} erreur(s), {len(cat.warnings)} avertissement(s)")
    return 1 if cat.errors else 0


if __name__ == "__main__":
    sys.exit(main())
