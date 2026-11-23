Cartes hors ligne embarquées dans l'app. Les fichiers .pmtiles et .mbtiles ne
sont pas versionnés (plusieurs Mo chacun) : ils sont produits par

    python3 tools/extract_maps.py --mbtiles --app-assets

depuis la racine du dépôt, en local comme dans la CI. Sans eux, l'app marche
mais l'écran « Essai carte » l'indique.
