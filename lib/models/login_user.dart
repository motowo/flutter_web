import 'package:firebase_auth/firebase_auth.dart';

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
