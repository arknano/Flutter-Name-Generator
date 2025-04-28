import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/appstate.dart';

//Sets the favourite status of a name and shows a snackbar message
//Favourited names are saved to disk
void setFavourite(bool favourite, BuildContext context, String name) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  if (favourite) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name added to favourites!')));
    updateSavedName(true, name);
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name removed from favourites!')));
    updateSavedName(false, name);
  }
}

// Adds or removes a name from the saved list based on the favourite status and persists it
Future<void> updateSavedName(bool favourite, String name) async {
  if (favourite) {
    if (!AppState().savedNames.contains(name)) {
      AppState().savedNames.add(name);
    }
  } else {
    AppState().savedNames.remove(name);
  }
  await _saveToPreferences();
}

// Clears all saved names and updates persistence
Future<void> clearNames() async {
  AppState().savedNames.clear();
  await _saveToPreferences();
}

// Helper method to persist the savedNames list
Future<void> _saveToPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('savedNames', AppState().savedNames);
}

// Loads saved names from persistent storage
Future<void> loadSavedNames() async {
  final prefs = await SharedPreferences.getInstance();
  AppState().savedNames = prefs.getStringList('savedNames') ?? [];
}