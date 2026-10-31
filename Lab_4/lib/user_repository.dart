import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Singleton repository that holds the user's data in memory and persists
/// it to EncryptedSharedPreferences via flutter_secure_storage.
///
/// Load once at app startup via loadData(), then both LoginPage and
/// ProfilePage share the same instance.
class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage keys.
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyFirstName = 'firstName';
  static const String _keyLastName = 'lastName';
  static const String _keyPhone = 'phone';
  static const String _keyEmail = 'email';

  // In-memory copies — populated by loadData().
  String username = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  /// Loads ALL variables from EncryptedSharedPreferences into memory.
  Future<void> loadData() async {
    username = await _storage.read(key: _keyUsername) ?? '';
    password = await _storage.read(key: _keyPassword) ?? '';
    firstName = await _storage.read(key: _keyFirstName) ?? '';
    lastName = await _storage.read(key: _keyLastName) ?? '';
    phone = await _storage.read(key: _keyPhone) ?? '';
    email = await _storage.read(key: _keyEmail) ?? '';
  }

  /// Saves ALL in-memory variables to EncryptedSharedPreferences.
  Future<void> saveData() async {
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
    await _storage.write(key: _keyFirstName, value: firstName);
    await _storage.write(key: _keyLastName, value: lastName);
    await _storage.write(key: _keyPhone, value: phone);
    await _storage.write(key: _keyEmail, value: email);
  }

  /// Clears credentials only (used by the Lab 4 "No" path).
  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
    username = '';
    password = '';
  }
}