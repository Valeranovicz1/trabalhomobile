import 'package:flutter/material.dart';
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/repositories/user_repository.dart';

class AuthViewModel with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  bool get isLoading => _isLoading;
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final user = UserRepository.loginUser(email: email, password: password);

    _setLoading(false);

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);

    await Future.delayed(const Duration(seconds: 1));

    final success = UserRepository.registerUser(
      name: name,
      email: email,
      password: password,
    );

    _setLoading(false);

    return success;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void refreshCurrentUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
