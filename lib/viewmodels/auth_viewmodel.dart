import 'package:flutter/material.dart';
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/services/api_service.dart';
import 'dart:io';

class AuthViewModel with ChangeNotifier {
  final ApiService _api = ApiService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? _token;
  String? get token => _token;

  AuthViewModel() {
    _tryAutoLogin();
  }

  Future<bool> _tryAutoLogin() async {
    await _api.loadToken();

    bool isValid = await _api.validateToken();
    if (!isValid) {
      await _api.clearToken();
      return false;
    }

    try {
      final userData = await _api.get('/users/me');

      _currentUser = User(
        id: userData['id'].toString(),
        name: userData['name'],
        email: userData['email'],
        imageUrl: userData['imageUri'],
        token: null,
      );

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool loginSuccess = await _api.login(email, password);

      if (!loginSuccess) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userData = await _api.get('/users/me');

      _currentUser = User(
        id: userData['id'].toString(),
        name: userData['name'],
        email: userData['email'],
        imageUrl: userData['imageUri'],
        token: null,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.post('/register', {
        'name': name,
        'email': email,
        'password': password,
      });
      final success = await login(email, password);
      _isLoading = false;
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser({
    required String newName,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {};
      if (newName.isNotEmpty) body['name'] = newName;
      if (newPassword.isNotEmpty) body['password'] = newPassword;

      if (body.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      await _api.put('/users/me', body);

      if (_currentUser != null) {
        _currentUser = User(
          id: _currentUser!.id,
          name: newName.isNotEmpty ? newName : _currentUser!.name,
          email: _currentUser!.email,
          token: _currentUser!.token,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.delete('/users/me');

      await logout();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfilePhoto(File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _api.uploadProfilePhoto(imageFile);

      if (_currentUser != null) {
        String newUrl = response['imageUri'] ?? response['image_url'];

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final urlWithCacheBust = "$newUrl?v=$timestamp";

        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          token: _currentUser!.token,
          imageUrl: urlWithCacheBust,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
