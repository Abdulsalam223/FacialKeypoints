// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorage {
//   final FlutterSecureStorage storage = const FlutterSecureStorage();

//   writeSecureData(String key, String value) async {
//     await storage.write(key: key, value: value);
//   }

//   readSecureData(String key) async {
//     String? value = await storage.read(key: key) ?? null;
//     print('Data read from secure storage: $value');
//     return value;
//   }

//   deleteSecureData(String key) async {
//     await storage.delete(key: key);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  Future<void> writeSecureData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> readSecureData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    print('Data read from shared preferences: $value');
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
