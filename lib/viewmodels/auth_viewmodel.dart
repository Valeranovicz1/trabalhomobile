import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetomobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class AuthViewModel with ChangeNotifier {
  final fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  void _onAuthStateChanged(fba.User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      final doc = await _db.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        _currentUser = User(
          user_id: firebaseUser.uid,
          name: data['name'],
          email: firebaseUser.email!,
          password: '',
        );
      } else {
        _currentUser = User(
          user_id: firebaseUser.uid,
          name: firebaseUser.displayName ?? "Usuário",
          email: firebaseUser.email!,
          password: '',
        );
      }
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
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbaUser = userCredential.user;
      if (fbaUser == null) {
        _setLoading(false);
        return false;
      }

      await fbaUser.updateDisplayName(name);

      final userModel = User(
        user_id: fbaUser.uid,
        name: name,
        email: email,
        password: '',
      );

      await _db.collection('users').doc(fbaUser.uid).set({
        'name': name,
        'email': email,
        'joined': FieldValue.serverTimestamp(),
      });

      _currentUser = userModel;

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
    final fbaUser = _auth.currentUser;
    if (fbaUser == null) {
      _setLoading(false);
      return false;
    }

    try {
      if (newName != _currentUser?.name) {
        await fbaUser.updateDisplayName(newName);
      }

      await _db.collection('users').doc(fbaUser.uid).update({'name': newName});

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
      final fbaUser = _auth.currentUser;
      if (fbaUser == null) {
        _setLoading(false);
        return false;
      }

      await _db.collection('users').doc(fbaUser.uid).delete();

      await fbaUser.delete();

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }
}
