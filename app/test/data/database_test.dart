import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  // Le schéma v1 est figé dans drift_schemas/. Dès la v2, la commande
  // `dart run drift_dev make-migrations` génère dans test/drift/ un test qui
  // migre une vraie base v1 et vérifie le résultat.
  test('la base créée correspond au schéma v1 sauvegardé', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    expect(db.schemaVersion, 1);

    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
        .get();
    final tables = rows.map((r) => r.read<String>('name')).toSet();

    final saved =
        jsonDecode(File('drift_schemas/app_database/drift_schema_v1.json').readAsStringSync()) as Map<String, Object?>;
    final entities = (saved['entities']! as List<Object?>).cast<Map<String, Object?>>();
    final savedTables = {
      for (final e in entities)
        if (e['type'] == 'table') (e['data']! as Map<String, Object?>)['name']! as String,
    };
    expect(tables, savedTables);
  });
}
