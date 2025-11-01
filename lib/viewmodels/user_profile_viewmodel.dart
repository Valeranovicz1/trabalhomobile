// lib/viewmodels/user_profile_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/repositories/user_repository.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';

class UserProfileViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;

  UserProfileViewModel(this._authViewModel);

  User? get currentUser => _authViewModel.currentUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> updateUser({
    required String newName,
    required String newPassword,
  }) async {
    if (currentUser == null) return false;

    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    final updatedUser = UserRepository.updateUser(
      userId: currentUser!.user_id,
      email: currentUser!.email,
      newName: newName,
      newPassword: newPassword,
    );

    if (updatedUser != null) {
      _authViewModel.refreshCurrentUser(updatedUser);
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }

  Future<bool> deleteAccount() async {
    if (currentUser == null) return false;

    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    final success = UserRepository.deleteUser(email: currentUser!.email);

    if (success) {
      _authViewModel.logout();
    }

    _setLoading(false);
    return success;
  }

  void logout() {
    _authViewModel.logout();
  }
}
