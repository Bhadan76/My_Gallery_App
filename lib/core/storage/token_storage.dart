import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'access_token';
  static String? _memoryToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2YTQwMjBjZWVkZDVhODYzMjU0NDY4MTYiLCJlbWFpbCI6InNhbWltY3NlN0BnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsInNlc3Npb25JZCI6ImVlYTk4NjY5LTZhYTctNGQ4My1iYmZhLTJlYTU1NDNlZjk0NiIsImlhdCI6MTc5NTU5OTc3MCwiZXhwIjoxNzk4MTkxNzcwfQ.u_J4-2K5Z--hQBd54etsBbpTGmEUZwDwuWcwi-MIYkE';

  Future<void> saveToken(String token) async {
    _memoryToken = token;
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('Secure storage write failed, using memory cache: $e');
    }
  }

  Future<String?> getToken() async {
    if (_memoryToken != null && _memoryToken!.isNotEmpty) {
      return _memoryToken;
    }
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        _memoryToken = token;
      }
      return token;
    } catch (e) {
      debugPrint('Secure storage read failed: $e');
      return _memoryToken;
    }
  }

  Future<void> deleteToken() async {
    _memoryToken = null;
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      debugPrint('Secure storage delete failed: $e');
    }
  }
}
