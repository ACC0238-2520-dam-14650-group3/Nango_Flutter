import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  static const String _keyNotificationBadge = 'notification_badge';
  static const String _keyNotificationRoutes = 'notification_routes';
  static const String _keyNotificationRequest = 'notification_request';
  static const String _keyNotificationChat = 'notification_chat';
  static const String _keyLanguage = 'language';

  PreferencesService._();

  static Future<PreferencesService> getInstance() async {
    _instance ??= PreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Notification Badge
  Future<bool> setNotificationBadge(bool value) async {
    return await _preferences!.setBool(_keyNotificationBadge, value);
  }

  bool getNotificationBadge() {
    return _preferences!.getBool(_keyNotificationBadge) ?? true;
  }

  // Notification Routes
  Future<bool> setNotificationRoutes(bool value) async {
    return await _preferences!.setBool(_keyNotificationRoutes, value);
  }

  bool getNotificationRoutes() {
    return _preferences!.getBool(_keyNotificationRoutes) ?? true;
  }

  // Notification Request
  Future<bool> setNotificationRequest(bool value) async {
    return await _preferences!.setBool(_keyNotificationRequest, value);
  }

  bool getNotificationRequest() {
    return _preferences!.getBool(_keyNotificationRequest) ?? false;
  }

  // Notification Chat
  Future<bool> setNotificationChat(bool value) async {
    return await _preferences!.setBool(_keyNotificationChat, value);
  }

  bool getNotificationChat() {
    return _preferences!.getBool(_keyNotificationChat) ?? true;
  }

  // Language
  Future<bool> setLanguage(String language) async {
    return await _preferences!.setString(_keyLanguage, language);
  }

  String getLanguage() {
    return _preferences!.getString(_keyLanguage) ?? 'en';
  }
}