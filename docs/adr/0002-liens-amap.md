# ADR 0002 — Liens vers Amap

- **État** : accepté
- **Date** : 23 novembre 2026

## Décision

L'app n'intègre pas de calcul d'itinéraire. Le bouton de la fiche ouvre `https://uri.amap.com/navigation?to=<lng>,<lat>,<nom>&mode=bus&src=bs-road&callnative=1`, avec des coordonnées converties de WGS-84 en GCJ-02. Pour un lieu à position approximative, il ouvre `https://uri.amap.com/search?keyword=<mots-clés chinois>&callnative=1`.

## Pourquoi

- Ce format a été vérifié avec le prototype web : il redirige vers la page d'itinéraire en transports d'Amap.
- `callnative=1` ouvre l'app Amap si elle est installée, sinon le navigateur.
- Amap est un site chinois : accessible en Chine sans VPN.
- La conversion GCJ-02 de l'app donne exactement les coordonnées du prototype (tests `geo_test.dart`).

## À faire plus tard

Les schémas natifs (`iosamap://path`, `androidamap://route/plan`) éviteraient le passage par le navigateur. Leurs paramètres sont à valider sur un téléphone avec Amap installé. Les déclarations nécessaires sont déjà en place : `LSApplicationQueriesSchemes` (iOS) et `<queries>` (Android).
