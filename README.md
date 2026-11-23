# BS Road

Carnet de sourcing pour un voyage d'achat en Chine : les marchés de gros et les boutiques à visiter, le nom chinois à montrer au chauffeur, le métro et le bus le plus proche, l'itinéraire dans Amap, et ses propres notes de boutiques. L'app est faite pour marcher **sans réseau** : en Chine, la plupart des services occidentaux sont bloqués.

Application Flutter (Android et iPhone). Elle succède au prototype web « Carnet Chine ».

Plan et architecture : [document de conception](https://claude.ai/artifact/YJjqSB4EGkyKtViogE4k5G) et [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## État

Phase 0 (fondations) terminée côté code, sauf l'essai de carte sur un vrai téléphone :

- catalogue de 43 lieux exporté du prototype, validé et compilé en paquet ;
- base locale (Drift) avec import du catalogue en une transaction, notes personnelles jamais écrasées ;
- liste filtrable par région, produit et texte (chinois compris), regroupée par quartier ;
- fiche lieu : plaque chinoise, plein écran chauffeur, métro et bus, statut, favori, note, lien Amap ;
- écran « Essai carte » pour comparer deux lecteurs de tuiles hors ligne ([ADR 0001](docs/adr/0001-carte-hors-ligne.md)).

## Organisation

```
app/        App Flutter (lib/, test/, tool/screenshots/)
catalog/    Source du catalogue : un fichier JSON par lieu, schémas, cartes à produire
tools/      Python : contrôle et construction du paquet catalogue, extraction des cartes
docs/       Architecture et décisions (ADR)
.github/    CI : app-ci, catalog-ci, release
```

## Démarrer

Prérequis : Flutter 3.50 (stable), Python 3.12, et pour Android le SDK Android avec Java 17.

```sh
pip install -r tools/requirements.txt
python3 tools/extract_maps.py --only chine guangzhou --mbtiles --app-assets   # cartes embarquées (~35 Mo)

cd app
flutter pub get
flutter run
```

Sans l'étape des cartes, l'app fonctionne ; seul l'écran « Essai carte » signale qu'il manque les fichiers.

## Commandes utiles

| Tâche | Commande (depuis `app/` sauf mention) |
| --- | --- |
| Tests | `flutter test` |
| Analyse | `flutter analyze` |
| Format | `dart format lib test tool` |
| Code généré (Drift) | `dart run build_runner build --delete-conflicting-outputs` |
| Nouvelle version du schéma de base | augmenter `schemaVersion`, écrire la migration, puis `dart run drift_dev make-migrations` |
| Captures d'écran sans téléphone | `flutter test tool/screenshots/screenshots_test.dart` (polices Noto CJK requises) |
| Contrôler le catalogue | `python3 tools/validate.py` (depuis la racine) |
| Reconstruire le catalogue embarqué | `python3 tools/build_bundle.py --app-asset` (depuis la racine) |
| Tests des outils | `python3 -m unittest discover -s tools` (depuis la racine) |

## Ajouter ou corriger un lieu

Voir [catalog/README.md](catalog/README.md). En bref : un fichier `catalog/places/<id>.json`, une pull request, la CI contrôle, tu fusionnes, une release publie le nouveau paquet.

## Données et licences

Cartes et arrêts : © contributeurs OpenStreetMap (ODbL), tuiles Protomaps. Styles de carte : Protomaps basemaps (BSD-3-Clause). Les textes du catalogue citent leurs sources dans chaque fiche.
