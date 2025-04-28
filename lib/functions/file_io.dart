import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';

// Copies the provided name to the system clipboard and shows a snackbar message
void copyToClipboard(
  BuildContext context,
  String name, {
  bool showSnackbar = true,
}) {
  if (showSnackbar) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name copied to clipboard!')));
  }
  _copyToSystemClipboard(name);
}

// Actually copies the name to the system clipboard
void _copyToSystemClipboard(String name) {
  final clipboard = SystemClipboard.instance;
  final item = DataWriterItem();
  item.add(Formats.plainText(name));
  clipboard?.write([item]);
}