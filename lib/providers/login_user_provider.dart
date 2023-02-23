import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/models/login_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/users_repository.dart';

final loginUserStateProvider =
    StateNotifierProvider<LoginUserController, LoginUser?>(
  (ref) => LoginUserController(ref),
);

class LoginUserController extends StateNotifier<LoginUser?> {
  final Ref _ref;
  LoginUserController(this._ref) : super(null);

  void loadLoginUser(User? user) async {
    logger.info(user);
    if (user == null) {
      logger.info("user == null");
      state = null;
    } else {
      logger.info("user != null");
      state = await _ref.read(userRepositoryProvider).loadUserInfo(user);
    }
    logger.info(state);
  }
}
