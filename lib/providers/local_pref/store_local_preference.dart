import 'package:shared_preferences/shared_preferences.dart';

class LocalPreference {
  static SharedPreferences? _preferences;

  static const _keyThemeMode = 'thememode';
  static const _keyVideoVolume = 'volumeControl';
  static const _keyIsOnlineMode = 'online';
  static const _keyvideoPageToken = 'pagetoken';
  static const _keysoureceImg = 'simg';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  //--------------------------------------------------------------
  static Future setVolume(bool? val) async =>
      await _preferences!.setBool(_keyVideoVolume, val!);
  static bool? getStoredVolume() => _preferences!.getBool(_keyVideoVolume);
//--------------------------------------------------------------

  static Future setThemeMode(bool? val) async =>
      await _preferences!.setBool(_keyThemeMode, val!);
  static bool? getStoredThemeMode() => _preferences!.getBool(_keyThemeMode);
  //--------------------------------------------------------------
  static Future setIsOnline(bool? val) async =>
      await _preferences!.setBool(_keyIsOnlineMode, val!);
  static bool? getStoredIsOnline() => _preferences!.getBool(_keyIsOnlineMode);
  //--------------------------------------------------------------
  static Future setvideoPageToken(int? val) async =>
      await _preferences!.setInt(_keyvideoPageToken, val!);
  static int? getvideoPageToken() => _preferences!.getInt(_keyvideoPageToken);
  //--------------------------------------------------------------
  static Future setSourceImage(String? val) async =>
      await _preferences!.setString(_keysoureceImg, val!);
  static String? getSourceImage() => _preferences!.getString(_keysoureceImg);
  // static Future setUserToken(String? tkn) async =>
  //     await _preferences!.setString(_keyToken, tkn!);
  // static String? getUserToken() => _preferences!.getString(_keyToken);

//--------------------------------------------------------------
}
