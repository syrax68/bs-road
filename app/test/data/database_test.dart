import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  // Chaque version du schéma est figée dans drift_schemas/ ; les migrations
  // entre versions sont testées dans test/drift/.
  test('une base neuve correspond au dernier schéma sauvegardé', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final file = File('drift_schemas/app_database/drift_schema_v${db.schemaVersion}.json');
    expect(file.existsSync(), isTrue, reason: 'Lancer dart run drift_dev make-migrations');

    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
        .get();
    final tables = rows.map((r) => r.read<String>('name')).toSet();

    final saved = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    final entities = (saved['entities']! as List<Object?>).cast<Map<String, Object?>>();
    final savedTables = {
      for (final e in entities)
        if (e['type'] == 'table') (e['data']! as Map<String, Object?>)['name']! as String,
    };
    expect(tables, savedTables);
  });
}
