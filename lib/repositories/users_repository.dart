import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/firebase_provider.dart';
import '../models/login_user.dart';

abstract class BaseUserInfoRepository {
  Future<LoginUser> loadUserInfo(User? user);
}

final userRepositoryProvider =
    Provider<UserInfoRepository>((ref) => UserInfoRepository(ref));

class UserInfoRepository implements BaseUserInfoRepository {
  final Ref _ref;
  final String _collectionName = 'users';

  const UserInfoRepository(this._ref);

  @override
  Future<LoginUser> loadUserInfo(User? user) async {
    logger.info(user);
    var value = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .doc(user?.uid)
        .get();
    logger.info("${value['userType']}, ${value['organization']}");
    return LoginUser(
        user: user,
        userType: value['userType'],
        organization: value['organization']);
  }
}
