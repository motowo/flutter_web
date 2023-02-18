import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, User?>(
  (ref) => AuthController(ref.read),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  AuthController(this._read) : super(null);

  @override
  User? get state => _read(authRepositoryProvider).getCurrentUser();

  Future<void> signIn(String email, String password) async {
    try {
      await _read(authRepositoryProvider).signInWithEmail(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
