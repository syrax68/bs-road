import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ouvre un lien hors de l'app (Amap, une source). Affiche un message court
/// si le téléphone ne sait pas l'ouvrir, au lieu d'échouer en silence.
Future<void> openExternal(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    ok = false;
  }
  if (!ok) {
    messenger?.showSnackBar(const SnackBar(content: Text('Impossible d’ouvrir le lien sur ce téléphone.')));
  }
}
