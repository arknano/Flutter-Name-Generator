import 'package:flutter/material.dart';
import '../functions/functions.dart' as func;

// The list card shown on the favourites
class SavedListCard extends StatefulWidget {
  const SavedListCard({super.key, this.name = '', this.onUnfavourited});

  final String name;
  final VoidCallback? onUnfavourited;

  @override
  State<SavedListCard> createState() => _SavedListCardState();
}

class _SavedListCardState extends State<SavedListCard> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => func.copyToClipboard(context, widget.name),
            ),
            IconButton(
              icon: const Icon(Icons.heart_broken),
              onPressed: () {
                func.setFavourite(false, context, widget.name);
                widget.onUnfavourited!();
              },
            ),
          ],
        ),
        selected: false,
      ),
    );
  }
}
