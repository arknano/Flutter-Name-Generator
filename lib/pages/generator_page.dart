import 'package:flutter/material.dart';
import '../data/appstate.dart';
import '../components/components.dart';
import '../functions/functions.dart' as func;

/// Page that displays generated names, allows new generation, and shows history.
class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Generates a new name and updates the display.
  void _generateNewName() {
    // Generate and store new name
    func.generateName();

    // Scroll to the bottom on next frame to show latest entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _CurrentNameDisplay(),
          const SizedBox(height: 16), // Space between name and button
          _GenerateButton(onGenerate: _generateNewName),
          const SizedBox(height: 16), // Space between button and list
          Flexible(child: _GeneratedNamesList(controller: _scrollController)),
        ],
      ),
    );
  }
}

/// Displays the currently generated name.
class _CurrentNameDisplay extends StatelessWidget {
  const _CurrentNameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Text(
        AppState().currentName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

/// Button to generate a new name.
class _GenerateButton extends StatelessWidget {
  final VoidCallback onGenerate;
  const _GenerateButton({required this.onGenerate, super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onGenerate,
      style: Theme.of(context).filledButtonTheme.style,
      child: const Text('Generate A Name'),
    );
  }
}

/// List of generated names with automatic scroll and history display.
class _GeneratedNamesList extends StatelessWidget {
  final ScrollController controller;
  const _GeneratedNamesList({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    dynamic history = AppState().generatedNames;

    if (history.isEmpty) {
      return const Center(child: Text('No names generated yet.'));
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      reverse: true,
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        return GeneratedListCard(name: history[index]);
      },
    );
  }
}
