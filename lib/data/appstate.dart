export 'name_generation_data.dart';

class AppState {
  // Private constructor
  AppState._internal();

  // The single instance of Global
  static final AppState _instance = AppState._internal();

  // Factory constructor to return the same instance
  factory AppState() {
    return _instance;
  }

  // Application state variables
  String currentName = 'Click to generate a name!';
  List<String> generatedNames = [];
  List<String> savedNames = [];

  String firstNameOverride = '';
  String lastNameOverride = '';
  String prefixOverride = '';
  bool lightMode = true;
}
