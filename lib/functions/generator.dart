import '../data/appstate.dart';
import 'dart:math';

/// Generates a name using a random enabled template.
void generateName() {
  final enabledTemplates =
      NameGenerationData().templates.where((t) => t.enabled).toList();
  if (enabledTemplates.isEmpty) {
    AppState().currentName =
        'You turned literally all the templates off, dumbass.';
    return;
  }
  final pattern =
      enabledTemplates[Random().nextInt(enabledTemplates.length)].pattern;
  AppState().currentName = generateNameFromTemplate(pattern);
  AppState().generatedNames.add(AppState().currentName);
}

/// Generates a name using the provided template pattern.
String generateNameFromTemplate(String pattern) {
  final overrides = Map<String, String>.fromEntries(
    AppState().overrides.entries.where((entry) => entry.value.isNotEmpty),
  );

  return '${_getAffix(true)}${_applyPattern(pattern, overrides)}${_getAffix(false)}';
}

String _getAffix(bool prefix) {
  String affix =
      prefix
          ? AppState().overrides['prefixOverride'] ?? ''
          : AppState().overrides['suffixOverride'] ?? '';
  if (!NameGenerationData().getGenerationSetting(
    prefix ? 'Always show prefix' : 'Always show suffix',
  )) {
    affix = Random().nextBool() ? affix : '';
  }
  if (affix.isNotEmpty) {
    affix = prefix ? '$affix ' : ' $affix';
  }
  return affix;
}

/// Applies the given pattern with the provided overrides.
String _applyPattern(String pattern, Map<String, String> overrides) {
  return pattern.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
    final key = match.group(1)!;
    if (overrides.containsKey(key)) {
      return overrides[key]!;
    }
    final bank = Config().wordLists[key];
    if (bank == null || bank.isEmpty) {
      throw StateError('No words for placeholder: $key');
    }
    return bank[Random().nextInt(bank.length)];
  });
}

/// Capitalizes the first letter of the given string.
// String _capitalize(String input) {
//   if (input.isEmpty) return input;
//   return input[0].toUpperCase() + input.substring(1);
// }
