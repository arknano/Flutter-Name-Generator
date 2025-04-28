import 'package:flutter/material.dart';
import '../data/appstate.dart';
import '../functions/functions.dart' as func;

/// Settings page with tabs for generation templates and word overrides.
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
              children: const [_TemplateSettingsTab(), _OverrideSettingsTab()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab for toggling name generation templates, including prefix.
/// Generates each template example once and caches subtitles.
class _TemplateSettingsTab extends StatefulWidget {
  const _TemplateSettingsTab({super.key});

  @override
  State<_TemplateSettingsTab> createState() => _TemplateSettingsTabState();
}

class _TemplateSettingsTabState extends State<_TemplateSettingsTab> {
  late final List<String> _cachedExamples;

  @override
  void initState() {
    super.initState();
    // Generate and cache one example per template
    _cachedExamples =
        NameGenerationData().templates
            .map((t) => func.generateNameFromTemplate(t.pattern))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // example bool toggle
        // SwitchListTile(
        //   title: const Text('Enable Prefix'),
        //   subtitle: const Text('Add a prefix to the name'),
        //   value: AppState().prefix,
        //   onChanged: (enabled) {
        //     AppState().prefix = enabled;
        //     setState(() {});
        //   },
        // ),
        const Divider(),
        // Dynamic template toggles with cached subtitles
        ...List.generate(NameGenerationData().templates.length, (index) {
          final template = NameGenerationData().templates[index];
          return SwitchListTile(
            title: Text(template.pattern),
            subtitle: Text('e.g. \"${_cachedExamples[index]}\"'),
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

/// Tab for setting manual word overrides.
class _OverrideSettingsTab extends StatelessWidget {
  const _OverrideSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        SizedBox(height: 16),
        _OverrideField(
          label: 'First Name Override',
          helper: 'Overrides the first name in the generated name',
          valueKey: _OverrideKey.firstName,
        ),
        SizedBox(height: 16),
                _OverrideField(
          label: 'Last Name Override',
          helper: 'Overrides the last name in the generated name',
          valueKey: _OverrideKey.lastName,
        ),
        SizedBox(height: 16),
        _OverrideField(
          label: 'Prefix',
          helper: 'Adds a prefix to the generated name',
          valueKey: _OverrideKey.prefix,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

/// Keys for identifying the override fields.
enum _OverrideKey { firstName, lastName, prefix }

/// Single text field for setting an override.
class _OverrideField extends StatefulWidget {
  final String label;
  final String helper;
  final _OverrideKey valueKey;

  const _OverrideField({
    required this.label,
    required this.helper,
    required this.valueKey,
    super.key,
  });

  @override
  State<_OverrideField> createState() => _OverrideFieldState();
}

class _OverrideFieldState extends State<_OverrideField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = switch (widget.valueKey) {
      _OverrideKey.firstName => AppState().firstNameOverride,
      _OverrideKey.lastName => AppState().lastNameOverride,
      _OverrideKey.prefix => AppState().prefixOverride,
    };
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final trimmed = value.trim();
    switch (widget.valueKey) {
      case _OverrideKey.firstName:
        AppState().firstNameOverride = trimmed;
        break;
      case _OverrideKey.lastName:
        AppState().lastNameOverride = trimmed;
        break;
      case _OverrideKey.prefix:
        AppState().prefixOverride = trimmed;
        break;
    }
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
