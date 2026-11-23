// Tests de migration de la base. Les fichiers generated/ sont produits par
// `dart run drift_dev make-migrations` à chaque nouvelle version du schéma.
import 'package:bs_road/data/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  group('chaque migration produit le schéma sauvegardé', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      for (final toVersion in versions.skip(i + 1)) {
        test('v$fromVersion vers v$toVersion', () async {
          final schema = await verifier.schemaAt(fromVersion);
          final db = AppDatabase(schema.newConnection());
          await verifier.migrateAndValidate(db, toVersion);
          await db.close();
        });
      }
    }
  });

  test('v1 vers v2 : les statuts et notes de l’utilisateur sont conservés', () async {
    // Valeurs brutes de SQLite : booléen en entier, date en secondes.
    final updated = DateTime.utc(2026, 11, 20).millisecondsSinceEpoch ~/ 1000;
    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) => batch.insertAll(oldDb.placeStates, [
        v1.PlaceStatesData(placeId: 'baima', status: 1, favorite: 1, note: 'Étage 3', updatedAt: updated),
      ]),
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.placeStates).get(), [
          v2.PlaceStatesData(placeId: 'baima', status: 1, favorite: 1, note: 'Étage 3', updatedAt: updated),
        ]);
        expect(await newDb.select(newDb.settings).get(), isEmpty);
      },
    );
  });
}
