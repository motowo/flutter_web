import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginUser {
  const LoginUser(
      {required this.user, required this.userType, required this.organization});
  final User? user;
  final String userType;
  final String organization;
  String? get uid => user?.uid;
  @override
  String toString() {
    return '$user, $userType, $organization';
  }
}
