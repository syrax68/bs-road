"""Tests des contrôles du catalogue. Usage : python3 -m unittest discover -s tools"""
import copy
import gzip
import json
import shutil
import tempfile
import unittest
from pathlib import Path

import catalog_lib
from catalog_lib import CATALOG, bundle, load, validate, write_bundle


class CatalogTest(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.dir = self.tmp / "catalog"
        shutil.copytree(CATALOG, self.dir)
        # Les messages d'erreur citent les chemins relativement à la racine du dépôt.
        self._root = catalog_lib.ROOT
        catalog_lib.ROOT = self.tmp

    def tearDown(self):
        catalog_lib.ROOT = self._root
        shutil.rmtree(self.tmp)

    def place(self, pid):
        return json.loads((self.dir / "places" / f"{pid}.json").read_text(encoding="utf-8"))

    def write(self, pid, data):
        (self.dir / "places" / f"{pid}.json").write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")

    def errors(self):
        return validate(load(self.dir), self.dir).errors

    def test_catalogue_du_depot_valide(self):
        self.assertEqual(self.errors(), [])

    def test_categorie_inconnue(self):
        p = self.place("buynow")
        p["categories"] = ["pc", "voitures"]
        self.write("buynow", p)
        self.assertTrue(any("catégorie inconnue « voitures »" in e for e in self.errors()))

    def test_id_different_du_fichier(self):
        p = self.place("buynow")
        p["id"] = "autre"
        self.write("buynow", p)
        self.assertTrue(any("doit être égal au nom du fichier" in e for e in self.errors()))

    def test_doublon_sur_le_nom_chinois(self):
        p = copy.deepcopy(self.place("buynow"))
        p["id"] = "buynow2"
        self.write("buynow2", p)
        self.assertTrue(any("même nom chinois" in e for e in self.errors()))

    def test_coordonnees_hors_de_chine(self):
        p = self.place("buynow")
        p["lat"] = -18.9  # Antananarivo
        self.write("buynow", p)
        self.assertTrue(any("lat" in e for e in self.errors()))

    def test_ville_hors_guangzhou_sans_groupe(self):
        p = self.place("yiwu")
        del p["group"]
        self.write("yiwu", p)
        self.assertTrue(any("group" in e for e in self.errors()))

    def test_signalement_sur_lieu_inconnu(self):
        (self.dir / "alerts" / "inconnu.json").write_text(
            json.dumps({"place": "inconnu", "type": "ferme", "text": "x", "date": "2026-01-01"}), encoding="utf-8"
        )
        self.assertTrue(any("lieu inconnu" in e for e in self.errors()))

    def test_paquet_reproductible(self):
        cat = validate(load(self.dir), self.dir)
        a = write_bundle(bundle(cat, 1, "2026-01-01T00:00:00Z"), self.tmp / "a")
        b = write_bundle(bundle(cat, 1, "2026-01-01T00:00:00Z"), self.tmp / "b")
        self.assertEqual(a["catalog"]["sha256"], b["catalog"]["sha256"])
        data = json.loads(gzip.decompress((self.tmp / "a" / a["catalog"]["file"]).read_bytes()))
        self.assertEqual(data["schemaVersion"], catalog_lib.SCHEMA_VERSION)
        self.assertEqual(len(data["places"]), len(cat.places))


if __name__ == "__main__":
    unittest.main()
