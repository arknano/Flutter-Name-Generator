import 'package:flutter/material.dart';
import 'pages/generator_page.dart';
import 'pages/favourites_page.dart';
import 'pages/settings_page.dart';
import 'data/appstate.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'functions/functions.dart' as func;

//Define the main screen of the app
class GeneratorApp extends StatefulWidget {
  const GeneratorApp({super.key});

  @override
  State<GeneratorApp> createState() => _GeneratorAppState();
}

class _GeneratorAppState extends State<GeneratorApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Title(
      title: Config().get('appName'),
      color: theme.colorScheme.primary,
      child: Scaffold(
        appBar: AppBar(title: Text(Config().get('appName')), ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          indicatorColor: theme.colorScheme.primary,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Generator',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            NavigationDestination(
              //icon: Badge(label: Text('2'), child: Icon(Icons.settings)),
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body:
            <Widget>[
              GeneratorPage(),
              FavouritesPage(),
              SettingsPage(),
            ][currentPageIndex],
      ),
    );
  }
}

// Actually run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Config().initialiseConfig();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    func.loadSavedNames();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: GeneratorApp(),
    ).animate().fadeIn(duration: 500.ms);
  }
}
