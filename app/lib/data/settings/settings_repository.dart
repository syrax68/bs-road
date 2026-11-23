import 'dart:convert';

import 'package:bs_road/data/db/app_database.dart';

/// Réglages de l'utilisateur rangés par clé, en JSON. Données personnelles :
/// jamais touchées par une mise à jour du catalogue, incluses dans la sauvegarde.
class SettingsRepository {
  SettingsRepository(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Valeur décodée, ou null si la clé est absente ou illisible.
  Stream<Object?> watch(String key) =>
      (_db.select(_db.settings)..where((t) => t.key.equals(key))).watchSingleOrNull().map((row) => _decode(row?.value));

  Future<Object?> read(String key) async =>
      _decode((await (_db.select(_db.settings)..where((t) => t.key.equals(key))).getSingleOrNull())?.value);

  Future<void> write(String key, Object? value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: jsonEncode(value), updatedAt: _clock()));

  static Object? _decode(String? raw) {
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }
}
