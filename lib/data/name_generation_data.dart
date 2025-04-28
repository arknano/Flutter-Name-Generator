import 'package:flutter/services.dart' show rootBundle;

class NameTemplate {
  final String pattern;
  bool enabled;

  NameTemplate(this.pattern, {this.enabled = true});
}

class NameGenerationData {
    // Private constructor
  NameGenerationData._internal();

  // The single instance of NameGenerator
  static final NameGenerationData _instance = NameGenerationData._internal();

  // Factory constructor to return the same instance
  factory NameGenerationData() {
    return _instance;
  }
  
  final List<NameTemplate> templates = [];

  final Map<String, List<String>> wordBanks = {
    'firstName': [],
    'lastName': [],
  };


  /// Loads all word lists from assets into the word banks.
  Future<void> initialiseWords() async {
    await loadAllNames();
    await loadTemplates();
  }

  /// Loads the templates from the assets file into the templates list.
  Future<void> loadTemplates() async {
    final loaded = await rootBundle.loadString('assets/names/templates.txt');
    final lines = loaded.split('\n').map((line) => line.trim()).toList();
    for (final line in lines) {
      if (line.isNotEmpty) {
        templates.add(NameTemplate(line));
      }
    }
  }

    /// Loads all word lists from assets into the word banks.
  Future<void> loadAllNames() async {
    wordBanks['firstName'] = await _loadNameList('assets/names/wordlist_first_names.txt');
    wordBanks['lastName'] = await _loadNameList('assets/names/wordlist_last_names.txt');
  }

  /// Loads a list of names from the given asset path.
  Future<List<String>> _loadNameList(String path) async {
    final loaded = await rootBundle.loadString(path);
    return loaded.split('\n').map((name) => name.trim()).toList();
  }

  /// Toggles the enabled state of a template at the given index.
  void toggleTemplate(int index, bool isEnabled) {
    if (index < 0 || index >= templates.length) {
      throw RangeError('Template index out of range');
    }
    templates[index].enabled = isEnabled;
  }

  /// Checks if the template at the given index is enabled.
  bool isTemplateEnabled(int index) {
    if (index < 0 || index >= templates.length) {
      throw RangeError('Template index out of range');
    }
    return templates[index].enabled;
  }
}
