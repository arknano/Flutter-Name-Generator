import 'package:flutter/material.dart';
import '../data/appstate.dart';
import '../components/components.dart';
import '../functions/functions.dart' as func;

/// A page displaying the user's favorite names with options
/// to clear all favorites or unfavourite individual entries.
class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  void _handleClearFavorites() {
    func.clearNames();
    setState(() {});
  }

  void _handleUnfavourited() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _ClearFavoritesButton(onCleared: _handleClearFavorites),
          const SizedBox(height: 16),
          Flexible(
            child: _FavoritesList(onUnfavourited: _handleUnfavourited),
          ),
        ],
      ),
    );
  }
}

/// Button to clear all saved favorites.
class _ClearFavoritesButton extends StatelessWidget {
  final VoidCallback onCleared;
  const _ClearFavoritesButton({required this.onCleared});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Clear All Favorites'),
      onPressed: () {
        func.clearNames();
        onCleared();
      },
    );
  }
}

/// List widget showing saved favorites or an empty state.
class _FavoritesList extends StatelessWidget {
  final VoidCallback onUnfavourited;
  const _FavoritesList({required this.onUnfavourited});

  @override
  Widget build(BuildContext context) {
    final saved = AppState().savedNames;

    if (saved.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            'No favorites saved yet! Click the heart icon to save a name!',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: saved.length,
      reverse: true,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SavedListCard(
          name: saved[index],
          onUnfavourited: onUnfavourited,
        );
      },
    );
  }
}
