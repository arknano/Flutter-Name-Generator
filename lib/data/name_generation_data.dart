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
  List<Map<String, dynamic>> generationSettings = [];

  bool getGenerationSetting(String key) {
    final setting = generationSettings.firstWhere(
      (setting) => setting['displayName'] == key,
      orElse: () => {'value': false},
    );
    return setting['value'] as bool;
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
