import 'package:shared_preferences/shared_preferences.dart';

/// Service to interact with SharedPreferences for storing and retrieving images paths
class SharedPreferencesService {

  /// Saves image file path to storage with the [fileName] as the key.
  /// Returns the result of set operation.
  static Future<bool> setFilePath(String fileName, String path) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(fileName, path);
  }

  /// Retrieves all keys from storage and get all values associated with keys.
  /// Returns values list, sorted from the latest to oldest (alphabetical sort
  /// is suitable because of the chosen file naming method).
  static Future<List<String>> getAllFilePaths() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<String> pathsList = List.empty(growable: true);
    for (String key in keys) {
      pathsList.add(prefs.getString(key)!);
    }
    pathsList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return pathsList.reversed.toList();
  }
}
