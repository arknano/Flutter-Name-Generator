import 'package:flutter/material.dart';
import '../data/appstate.dart';
import '../functions/functions.dart' as func;

/// Main settings page with tabs for name templates and dynamic word overrides.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.settings), text: 'Name Templates'),
              Tab(icon: Icon(Icons.edit), text: 'Word Overrides'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TemplateSettingsTab(),
                OverrideSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab for toggling name generation templates.
class TemplateSettingsTab extends StatefulWidget {
  const TemplateSettingsTab({super.key});

  @override
  State<TemplateSettingsTab> createState() => _TemplateSettingsTabState();
}

class _TemplateSettingsTabState extends State<TemplateSettingsTab> {
  late final List<String> _cachedExamples;

  @override
  void initState() {
    super.initState();
    _cachedExamples = NameGenerationData().templates
        .map((t) => func.generateNameFromTemplate(t.pattern))
        .toList();
  }

   @override
  Widget build(BuildContext context) {
    final templates = NameGenerationData().templates;

    // Create toggle widgets from generationSettings
    final generationToggles = NameGenerationData().generationSettings.map((entry) {
      return SwitchListTile(
        title: Text(entry['displayName'] as String),
        value: entry['value'] as bool,
        onChanged: (enabled) {
          setState(() {
            entry['value'] = enabled;  // Update the value in the list
          });
        },
      );
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        const Divider(),
        // Insert generation settings toggles at the top
        ...generationToggles,
        // Then the regular template toggles
        ...List.generate(templates.length, (index) {
          final template = templates[index];
          return SwitchListTile(
            title: Text(template.pattern),
            subtitle: Text('e.g. "${_cachedExamples[index]}"'),
            value: NameGenerationData().isTemplateEnabled(index),
            onChanged: (enabled) {
              NameGenerationData().toggleTemplate(index, enabled);
              setState(() {});
            },
          );
        }),
      ],
    );
  }
}

/// Tab for setting manual word overrides dynamically from config.
class OverrideSettingsTab extends StatefulWidget {
  const OverrideSettingsTab({super.key});

  @override
  State<OverrideSettingsTab> createState() => _OverrideSettingsTabState();
}

class _OverrideSettingsTabState extends State<OverrideSettingsTab> {
  late final List<Map<String, dynamic>> _overrideFields;

  @override
  void initState() {
    super.initState();
    // Load override field definitions from config
    final lists = Config().get('wordLists') as List<dynamic>;
    _overrideFields = lists
        .map((e) => e as Map<String, dynamic>)
        .where((entry) => entry.containsKey('displayName'))
        .toList();

    // Add manual overrides for Prefix and Suffix
    _overrideFields.insert(0, {
      'key': 'prefixOverride', 
      'displayName': 'Prefix', 
    });

    _overrideFields.add({
      'key': 'suffixOverride', 
      'displayName': 'Suffix', 
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: _overrideFields.map((field) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _OverrideField(
            valueKey: field['key'] as String,
            label: '${field['displayName'] as String} Override',
            helper: "Overrides the ${field['displayName'] as String} in the generated name",
          ),
        );
      }).toList(),
    );
  }
}


/// Single text field for setting an override, keyed dynamically.
class _OverrideField extends StatefulWidget {
  final String label;
  final String helper;
  final String valueKey;

  const _OverrideField({
    required this.label,
    required this.helper,
    required this.valueKey,
  });

  @override
  State<_OverrideField> createState() => _OverrideFieldState();
}

class _OverrideFieldState extends State<_OverrideField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Use a dynamic map in AppState for overrides
    final initial = AppState().overrides[widget.valueKey] ?? '';
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    AppState().overrides[widget.valueKey] = value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
        helperText: widget.helper,
      ),
      onChanged: _onChanged,
    );
  }
}
