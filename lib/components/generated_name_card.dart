import 'package:flutter/material.dart';
import '../data/appstate.dart';
import '../functions/functions.dart' as func;

// The list card shown on the generator page
class GeneratedListCard extends StatefulWidget {
  const GeneratedListCard({super.key, this.name = ''});

  final String name;

  @override
  State<GeneratedListCard> createState() => _GeneratedListCardState();
}

class _GeneratedListCardState extends State<GeneratedListCard> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = AppState().savedNames.contains(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.name),
        selected: _selected,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => func.copyToClipboard(context, widget.name),
            ),
            IconButton(
              icon: Icon(_selected ? Icons.heart_broken : Icons.favorite),
              onPressed: () {
                func.setFavourite(!_selected, context, widget.name);
                setState(() {
                  _selected = !_selected;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
