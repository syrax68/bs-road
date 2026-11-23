# ADR 0001 — Lecteur de carte hors ligne

- **État** : en essai (phase 0), à trancher sur un vrai téléphone
- **Date** : 23 novembre 2026

## Contexte

La carte doit s'afficher sans réseau en Chine. Le prototype web lisait des tuiles vectorielles OpenStreetMap (build Protomaps) rangées dans ses fichiers. Pour Flutter, deux options sérieuses avec `flutter_map` 8 :

| | A. PMTiles | B. MBTiles |
| --- | --- | --- |
| Lecteur | `vector_map_tiles` 9.0.0-beta.9 + `vector_map_tiles_pmtiles` 1.5.2 | `flutter_map_vector_tiles` 2.12.0 + `flutter_map_vector_tiles_mbtiles` 1.0.0 |
| Maturité | bêta | stable |
| Fichier | un `.pmtiles` par région | un `.mbtiles` (SQLite) par région |
| Style | thèmes Protomaps fournis | style MapLibre (on embarque le style Protomaps v4) |

Note : `flutter_map_vector_tiles` lit aussi les PMTiles, mais seulement par HTTP. Lire un PMTiles local avec lui demanderait un petit fournisseur maison (quatre méthodes), en réutilisant son décodeur PMTiles.

## Mesures faites (poste de développement, 23 novembre 2026)

Extraction avec `tools/extract_maps.py` depuis le build Protomaps du 22 novembre 2026 :

| Paquet | Zooms | Tuiles | PMTiles | MBTiles |
| --- | --- | --- | --- | --- |
| Chine, vue d'ensemble | 0 à 7 | 163 | 9,5 Mo | 9,7 Mo |
| Guangzhou, centre | 8 à 15 | 357 | 7,6 Mo | 7,9 Mo |

Rendu dans un test Flutter (machine Linux, pas un téléphone) : les deux affichent Guangzhou hors ligne avec les repères des lieux. Après 4 secondes, A laissait encore une tuile vide ; B avait tout dessiné. Ni l'un ni l'autre n'affiche encore les noms de rues (polices de la carte à régler en phase 2).

Ces chiffres ne disent rien de la fluidité sur un téléphone : c'est l'objet de l'essai.

## Protocole de l'essai

1. `python3 tools/extract_maps.py --only chine guangzhou --mbtiles --app-assets`, puis installer l'app sur le téléphone du voyage.
2. Mode avion. Ouvrir « Essai carte » (icône carte en haut de la liste).
3. Pour chaque option : zoomer et déplacer la carte 30 secondes, noter le temps d'ouverture, la moyenne d'images et le pourcentage d'images lentes affichés en bas, et les tuiles qui restent vides.

## Critères de choix

1. Fluidité sur le téléphone du voyage (moins de 10 % d'images au-delà de 16,7 ms).
2. Pas de tuile vide après 2 secondes d'arrêt.
3. Maturité du paquet (une bêta coûte plus en maintenance).
4. Noms chinois lisibles et thème sombre (phase 2).

## Penchant actuel

B (MBTiles, stable), sauf si l'essai sur téléphone le contredit. Le pipeline produit déjà les deux formats ; le choix ne change que le lecteur et le format publié.
