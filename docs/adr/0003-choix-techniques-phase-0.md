# ADR 0003 — Choix techniques de la phase 0

- **État** : accepté
- **Date** : 23 novembre 2026

Écarts et précisions par rapport au document de conception, décidés en écrivant la phase 0.

| Sujet | Document de conception | Retenu | Pourquoi |
| --- | --- | --- | --- |
| Flutter | dernière stable | 3.50.1, Dart 3.14 | Stable du 20 novembre 2026. Material vient du paquet `material_ui` (découplé du framework depuis 3.44). |
| Riverpod | Riverpod 3 + `riverpod_generator` | Riverpod 3.5, providers écrits à la main | Moins de code généré pour une petite app ; tout reste testable par remplacement de providers. |
| Modèles | `freezed` + `json_serializable` | Classes simples et lecture JSON manuelle | Le lecteur de paquet dit précisément quel lieu est incomplet ; un import raté laisse l'ancien catalogue. |
| Recherche | SQLite FTS5 | Filtre en Dart sur les lieux en mémoire | 43 lieux aujourd'hui, quelques centaines demain : instantané, et la recherche sans accents est plus simple à tester. FTS5 si le catalogue dépasse ~1 000 lieux. |
| Police chinoise | Noto embarquée | Polices du système + `locale: zh-CN` sur les textes chinois | Android et iOS ont des polices chinoises ; l'indication de langue évite les variantes japonaises des caractères. Économise ~10 Mo. |
| Lint | `very_good_analysis` | `very_good_analysis` 11, largeur 120, syntaxe classique des constructeurs | La règle `unnecessary_type_name_in_constructor` (syntaxe `new(...)` de Dart 3.14) est désactivée pour rester lisible. |
| Base | Drift | Drift 2.35 ; schéma v1 sauvegardé dans `app/drift_schemas/` | Les tests de migration générés arrivent avec la v2 (`dart run drift_dev make-migrations`). |
| SQLite natif | `sqlite3_flutter_libs` | Rien à ajouter | `sqlite3` 3.x embarque SQLite par build hooks ; `sqlite3_flutter_libs` est obsolète. |
