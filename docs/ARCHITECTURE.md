# Architecture

Résumé technique du [document de conception](https://claude.ai/artifact/YJjqSB4EGkyKtViogE4k5G). Les écarts avec ce document sont consignés dans les ADR de `docs/adr/`.

## Principe

L'app doit fonctionner en mode avion du début à la fin. Le réseau sert seulement à recevoir un nouveau catalogue et de nouvelles cartes avant ou pendant le voyage. Aucune dépendance aux services Google ni à claude.ai.

## Flux des données

```
catalog/places/*.json ──(CI : validate + build_bundle)──> catalog-<version>.json.gz + latest.json
                                                                    │ release GitHub
                                                                    ▼
assets/catalog/catalog.json.gz ──(premier lancement)──> CatalogImporter ──> base SQLite (Drift)
                                                                    │
                       écrans <── providers Riverpod <── dépôts <───┘
```

La base contient deux zones qui ne se touchent jamais :

- **catalogue** (`Places`, `Categories`, `Zones`, `TransitStops`, `Alerts`…) : remplacé en bloc, dans une seule transaction, à chaque import d'un paquet plus récent ;
- **données personnelles** (`PlaceStates` : statut, favori, note) : écrites seulement par l'utilisateur, rattachées aux lieux par leur identifiant texte, conservées même si le lieu sort du catalogue.

## Couches

```
lib/
  app/        démarrage, routes (go_router), thème, providers globaux
  core/       géo (WGS-84 → GCJ-02, distances), liens Amap, ouverture de liens
  data/       base Drift, lecture et import du paquet catalogue
  features/<fonction>/
    domain/        entités et règles pures (filtrer, regrouper) — sans Flutter
    data/          dépôts branchés sur la base
    presentation/  écrans, widgets, providers
```

Règles :

- `presentation` dépend de `domain` ; `data` fournit les objets de `domain` ; `domain` ne dépend de rien d'autre que `core`.
- Une fonctionnalité n'importe pas le code d'une autre ; ce qui est partagé vit dans `core/` ou `data/`.
- Toutes les coordonnées sont stockées en WGS-84 ; la conversion GCJ-02 ne se fait qu'en construisant un lien Amap.
- Les providers Riverpod sont déclarés à la main (sans génération de code) ; la base et les fichiers embarqués passent par `databaseProvider` et `assetBundleProvider`, remplacés dans les tests.

## Tests

| Niveau | Où | Ce qui est vérifié |
| --- | --- | --- |
| Outils | `tools/test_catalog_lib.py` | contrôles du catalogue, paquet reproductible |
| Unitaires | `app/test/core`, `app/test/data` | GCJ-02 identique au prototype, distances, lecture et import du paquet, notes conservées, paquet invalide sans effet, schéma v1 |
| Domaine | `app/test/features/places/place_filter_test.dart` | filtres, recherche sans accents et en chinois, regroupement par quartier |
| Écrans | `app/test/features/places/places_screens_test.dart` | premier lancement hors ligne, filtre, fiche, statut enregistré, plein écran chauffeur |
| Visuel | `app/tool/screenshots/` | captures en clair et en sombre, carte avec les deux lecteurs (hors CI) |

## Décisions

| ADR | Sujet | État |
| --- | --- | --- |
| [0001](adr/0001-carte-hors-ligne.md) | Lecteur de carte hors ligne | En essai sur téléphone |
| [0002](adr/0002-liens-amap.md) | Liens vers Amap | Accepté |
| [0003](adr/0003-choix-techniques-phase-0.md) | Choix techniques de la phase 0 | Accepté |
