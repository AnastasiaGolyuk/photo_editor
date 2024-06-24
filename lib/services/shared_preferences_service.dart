import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<bool> setFilePath(String fileName, String path) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(fileName, path);
  }

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
