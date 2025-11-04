import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetomobile/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class AuthViewModel with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  late StreamSubscription<fba.User?> _authStateSubscription;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthViewModel() {
    _authStateSubscription = fba.FirebaseAuth.instance
        .authStateChanges()
        .listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(fba.User? firebaseUser) {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      _currentUser = User(
        user_id: firebaseUser.uid,
        name: firebaseUser.displayName ?? "Usuário",
        email: firebaseUser.email!,
        password: '',
      );
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final userCredential = await fba.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      if (userCredential.user != null) {
        _onAuthStateChanged(userCredential.user);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await fba.FirebaseAuth.instance.signOut();
  }

  Future<bool> updateUser({
    required String newName,
    required String newPassword,
  }) async {
    _setLoading(true);
    final fbaUser = fba.FirebaseAuth.instance.currentUser;
    if (fbaUser == null) {
      _setLoading(false);
      return false;
    }
    try {
      if (newName != _currentUser?.name) {
        await fbaUser.updateDisplayName(newName);
      }
      if (newPassword.isNotEmpty) {
        await fbaUser.updatePassword(newPassword);
      }
      _currentUser = User(
        user_id: fbaUser.uid,
        name: newName,
        email: fbaUser.email!,
        password: '',
      );
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    _setLoading(true);
    try {
      await fba.FirebaseAuth.instance.currentUser?.delete();
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
