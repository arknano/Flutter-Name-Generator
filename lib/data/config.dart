import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'name_generation_data.dart';

// Contains immutable configuration data for the app, loaded from disk
// If it needs to be changed inside the app, it should use shared_preferences instead
class Config {
  // Private constructor
  Config._internal();

  // The single instance of Global
  static final Config _instance = Config._internal();

  // Factory constructor to return the same instance
  factory Config() {
    return _instance;
  }

  // The json is loaded into this dynamic map, so we can access whatever we want
  // without having to define a class for it
  Map<String, dynamic> config = {};

  /// Loads all word lists from assets into the word banks.
  Future<void> initialiseConfig() async {
    await _loadConfigJson();
    await _loadGenerationBools();
    await _loadWordLists();
    await _loadTemplates();
  }

  Future<void> _loadConfigJson() async {
    final jsonStr = await rootBundle.loadString(
      'assets/config.json',
    );
    config = json.decode(jsonStr);
  }

  dynamic get(String key) {
    return config[key];
  }

  Future<void> _loadGenerationBools() async {
    NameGenerationData().generationSettings = (config['generationSettings'] as List<dynamic>)
          .map((e) => {
            'displayName': e['displayName'],
            'value': e['value']
          })
          .toList();
    
  }

////////// WORD LISTS //////////

  final Map<String, List<String>> wordLists = {};

  /// Loads all word lists defined in the config file.
  Future<void> _loadWordLists() async {
    final List<dynamic> lists = Config().get('wordLists') ?? [];

    for (final dynamic listEntry in lists) {
      if (listEntry is Map<String, dynamic>) {
        final String name = listEntry['key'];
        final String path = listEntry['path'];
        wordLists[name] = await _parseWordListFile(path);
      }
    }
  }

  /// Loads the templates from the assets file into the templates list.
  Future<void> _loadTemplates() async {
    final loaded = await rootBundle.loadString(config['generatorTemplatesPath']);
    final lines = loaded.split('\n').map((line) => line.trim()).toList();
    for (final line in lines) {
      if (line.isNotEmpty) {
        //We store the templates in the NameGenerationData class
        //because they have mutable data (enabled/disabled)
        NameGenerationData().templates.add(NameTemplate(line));
      }
    }
  }
}

/// Loads a list of names from the given asset path.
  Future<List<String>> _parseWordListFile(String path) async {
    final String fileContent = await rootBundle.loadString(path);
    return fileContent.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

Future<Map<String, String>> loadConfig() async {
  final jsonStr = await rootBundle.loadString(
    'assets/config.json',
  );
  final Map<String, dynamic> doc = json.decode(jsonStr);
  final Map<String, dynamic> lists = doc['lists'] as Map<String, dynamic>;
  return lists.map((key, value) => MapEntry(key, value as String));
}
