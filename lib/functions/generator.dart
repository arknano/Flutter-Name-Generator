import '../data/appstate.dart';
import 'dart:math';
  
  /// Generates a name using a random enabled template.
  void generateName() {
    final enabledTemplates = NameGenerationData().templates.where((t) => t.enabled).toList();
    if (enabledTemplates.isEmpty) {
      AppState().currentName = 'You turned literally all the templates off, dumbass.';
      return;
    }
    final pattern = enabledTemplates[Random().nextInt(enabledTemplates.length)].pattern;
    AppState().currentName = generateNameFromTemplate(pattern);
    AppState().generatedNames.add(AppState().currentName);
  }

  /// Generates a name using the provided template pattern.
  String generateNameFromTemplate(String pattern) {
    final overrides = <String, String>{
      if (AppState().firstNameOverride.isNotEmpty) 'firstName': AppState().firstNameOverride,
      if (AppState().lastNameOverride.isNotEmpty) 'firstName': AppState().lastNameOverride,
    };

    return '${AppState().prefixOverride} ${_applyPattern(pattern, overrides)}';
  }

  /// Applies the given pattern with the provided overrides.
  String _applyPattern(String pattern, Map<String, String> overrides) {
    return pattern.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
      final key = match.group(1)!;
      if (overrides.containsKey(key)) {
        return overrides[key]!;
      }
      final bank = NameGenerationData().wordBanks[key];
      if (bank == null || bank.isEmpty) {
        throw StateError('No words for placeholder: $key');
      }
      return bank[Random().nextInt(bank.length)];
    });
  }

  /// Capitalizes the first letter of the given string.
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }