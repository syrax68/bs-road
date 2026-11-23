"""Lecture, contrôle et construction du catalogue BS Road.

Le catalogue source vit dans catalog/ (un fichier JSON par lieu et par signalement).
Ce module le charge, le contrôle et en tire le paquet que l'app télécharge.
"""
from __future__ import annotations

import gzip
import hashlib
import json
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "catalog"

# Version du format du paquet. L'app refuse un paquet d'un format plus récent qu'elle.
# À augmenter seulement pour un changement incompatible (champ obligatoire ajouté, sens changé).
SCHEMA_VERSION = 1


@dataclass
class Catalog:
    categories: list[dict]
    zones: list[dict]
    places: list[dict]
    alerts: list[dict]
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)


def _read_json(path: Path, errors: list[str]):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"{path.relative_to(ROOT)} : JSON illisible ({exc})")
        return None


def load(catalog_dir: Path = CATALOG) -> Catalog:
    errors: list[str] = []
    categories = _read_json(catalog_dir / "categories.json", errors) or []
    zones = _read_json(catalog_dir / "zones.json", errors) or []
    places, alerts = [], []
    for p in sorted((catalog_dir / "places").glob("*.json")):
        data = _read_json(p, errors)
        if data is not None:
            places.append((p, data))
    for p in sorted((catalog_dir / "alerts").glob("*.json")):
        data = _read_json(p, errors)
        if data is not None:
            alerts.append((p, data))
    cat = Catalog(categories, zones, [d for _, d in places], [d for _, d in alerts], errors)
    cat._files = {"places": places, "alerts": alerts}  # type: ignore[attr-defined]
    return cat


def validate(cat: Catalog, catalog_dir: Path = CATALOG) -> Catalog:
    """Contrôle le schéma JSON puis les règles qui croisent plusieurs fichiers."""
    try:
        from jsonschema import Draft202012Validator
    except ImportError:  # pragma: no cover - message pour un poste sans dépendances
        cat.errors.append("Module jsonschema absent : pip install -r tools/requirements.txt")
        return cat

    place_schema = json.loads((catalog_dir / "schema/place.schema.json").read_text(encoding="utf-8"))
    alert_schema = json.loads((catalog_dir / "schema/alert.schema.json").read_text(encoding="utf-8"))
    pv, av = Draft202012Validator(place_schema), Draft202012Validator(alert_schema)

    cat_ids = [c.get("id") for c in cat.categories]
    zone_ids = [z.get("id") for z in cat.zones]
    if len(set(cat_ids)) != len(cat_ids):
        cat.errors.append("categories.json : identifiant en double")
    if len(set(zone_ids)) != len(zone_ids):
        cat.errors.append("zones.json : identifiant en double")

    seen_zh: dict[str, str] = {}
    place_ids: set[str] = set()
    for path, place in cat._files["places"]:  # type: ignore[attr-defined]
        name = path.relative_to(ROOT)
        for err in sorted(pv.iter_errors(place), key=lambda e: list(e.path)):
            where = "/".join(str(x) for x in err.path) or "(racine)"
            cat.errors.append(f"{name} : {where} : {err.message}")
        pid = place.get("id")
        if pid != path.stem:
            cat.errors.append(f"{name} : l'id « {pid} » doit être égal au nom du fichier")
        if pid in place_ids:
            cat.errors.append(f"{name} : id en double")
        place_ids.add(pid)
        for c in place.get("categories", []):
            if c not in cat_ids:
                cat.errors.append(f"{name} : catégorie inconnue « {c} »")
        zone = place.get("zone")
        if zone is not None and zone not in zone_ids:
            cat.errors.append(f"{name} : quartier inconnu « {zone} »")
        if zone is not None and place.get("city") != "gz":
            cat.errors.append(f"{name} : un quartier n'a de sens qu'à Guangzhou")
        zh = (place.get("zh") or "").replace(" ", "")
        if zh in seen_zh:
            cat.errors.append(f"{name} : même nom chinois que {seen_zh[zh]} (doublon ?)")
        seen_zh[zh] = pid
        for s in place.get("sources", []):
            if str(s.get("url", "")).startswith("http://"):
                cat.warnings.append(f"{name} : source en http, pas en https ({s['url']})")
        if not place.get("sources"):
            cat.warnings.append(f"{name} : aucune source")

    for path, alert in cat._files["alerts"]:  # type: ignore[attr-defined]
        name = path.relative_to(ROOT)
        for err in av.iter_errors(alert):
            where = "/".join(str(x) for x in err.path) or "(racine)"
            cat.errors.append(f"{name} : {where} : {err.message}")
        if alert.get("place") != path.stem:
            cat.errors.append(f"{name} : « place » doit être égal au nom du fichier")
        if alert.get("place") not in place_ids:
            cat.errors.append(f"{name} : lieu inconnu « {alert.get('place')} »")
    return cat


def default_version(now: datetime | None = None) -> int:
    """Version croissante lisible : AAAAMMJJHHMM en UTC."""
    now = now or datetime.now(timezone.utc)
    return int(now.strftime("%Y%m%d%H%M"))


def bundle(cat: Catalog, version: int, published_at: str) -> dict:
    """Le paquet tel que l'app le lit. Ordre stable pour des builds reproductibles."""
    return {
        "schemaVersion": SCHEMA_VERSION,
        "version": version,
        "publishedAt": published_at,
        "categories": cat.categories,
        "zones": cat.zones,
        "places": sorted(cat.places, key=lambda p: p["id"]),
        "alerts": sorted(cat.alerts, key=lambda a: a["place"]),
    }


def write_bundle(data: dict, out_dir: Path) -> dict:
    """Écrit catalog-<version>.json.gz et latest.json ; renvoie le manifeste."""
    out_dir.mkdir(parents=True, exist_ok=True)
    raw = json.dumps(data, ensure_ascii=False, separators=(",", ":"), sort_keys=False).encode("utf-8")
    # mtime=0 : même contenu, même fichier, même empreinte.
    gz = gzip.compress(raw, compresslevel=9, mtime=0)
    name = f"catalog-{data['version']}.json.gz"
    (out_dir / name).write_bytes(gz)
    manifest = {
        "schemaVersion": data["schemaVersion"],
        "version": data["version"],
        "publishedAt": data["publishedAt"],
        "catalog": {"file": name, "bytes": len(gz), "sha256": hashlib.sha256(gz).hexdigest()},
        "places": len(data["places"]),
        "alerts": len(data["alerts"]),
    }
    (out_dir / "latest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest
