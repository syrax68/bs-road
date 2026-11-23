# Catalogue

Source de vérité des lieux de l'app. L'app ne lit jamais ces fichiers : elle lit un paquet compilé (`catalog-<version>.json.gz`) produit par `tools/build_bundle.py` et publié par la CI.

## Fichiers

| Fichier | Contenu |
| --- | --- |
| `places/<id>.json` | Un lieu. Format : `schema/place.schema.json` |
| `alerts/<id>.json` | Un signalement sur un lieu existant (fermé, à revérifier, info). Format : `schema/alert.schema.json` |
| `categories.json` | Catégories de produits, dans l'ordre d'affichage |
| `zones.json` | Quartiers de Guangzhou (A à K), dans l'ordre d'affichage |
| `map_packs.json` | Régions de carte hors ligne à découper |

La version 1 (43 lieux) a été exportée du prototype web Carnet Chine le 23 novembre 2026.

## Ajouter un lieu

1. Créer `places/<id>.json`. L'`id` est en minuscules, sans espace, et ne change plus jamais : les notes de l'utilisateur y sont rattachées.
2. Remplir les champs obligatoires du schéma. Textes en français, au tutoiement. Ce qu'on ne sait pas : « Non trouvé. », jamais inventé.
3. Position en WGS-84 (GPS, OpenStreetMap). Si elle est approximative, le dire dans `approx` (« placé sur la station de métro X »).
4. Au moins une source, de préférence deux, de moins de 18 mois.
5. Lancer `python3 tools/validate.py`, puis ouvrir une pull request.

Le champ `transit` (arrêts proches) est calculé depuis OpenStreetMap ; ne pas l'écrire à la main.

## Signaler un changement

Un fichier `alerts/<id du lieu>.json` avec `type` (`ferme`, `verifier` ou `info`), `text`, `date` et si possible `source`. Supprimer le fichier quand le signalement n'est plus vrai. On ne supprime pas un lieu fermé : on le signale.

## Format du paquet

`tools/catalog_lib.py` : `SCHEMA_VERSION` (format du paquet) doit être égal à `supportedCatalogSchema` dans `app/lib/data/catalog/catalog_bundle.dart`. L'augmenter seulement pour un changement incompatible ; l'app refuse alors les paquets trop récents et garde son catalogue.
