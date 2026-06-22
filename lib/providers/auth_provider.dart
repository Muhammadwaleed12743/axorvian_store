import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check for hardcoded dummy login
    if (username == 'waleed' && password == 'waleedpass') {
      final dummyData = {
        'id': 999,
        'username': 'waleed',
        'email': 'waleed@example.com',
        'firstName': 'Waleed',
        'lastName': 'User',
        'gender': 'male',
        'image': 'https://dummyjson.com/icon/waleed/128',
        'accessToken': 'dummy_token_waleed',
      };
      
      _user = AppUser.fromJson(dummyData);
      _user!.address = '4820 Redwood St, San Francisco, CA 94114';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', _user!.token);
      await prefs.setString('user_data', jsonEncode(dummyData));
      
      _isLoading = false;
      notifyListeners();
      return true;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppStrings.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 60,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _user = AppUser.fromJson(data);
        _user!.address = '4820 Redwood St, San Francisco, CA 94114';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', _user!.token);
        await prefs.setString('user_data', jsonEncode(data));
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String firstName, String lastName, String email,
      String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${AppStrings.baseUrl}/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Signup failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      try {
        final data = jsonDecode(userData) as Map<String, dynamic>;
        _user = AppUser.fromJson(data);
        _user!.address = '4820 Redwood St, San Francisco, CA 94114';
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');
    notifyListeners();
  }
}
