import 'package:shared_preferences/shared_preferences.dart';

class ResourceService {
  static final ResourceService _instance = ResourceService._();
  factory ResourceService() => _instance;
  ResourceService._();

  Future<bool> areResourcesDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('resources_downloaded') ?? false;
  }

  Future<void> markResourcesDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('resources_downloaded', true);
  }

  Future<int> getResourceVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('resource_version') ?? 0;
  }

  Future<void> setResourceVersion(int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('resource_version', version);
  }
}
