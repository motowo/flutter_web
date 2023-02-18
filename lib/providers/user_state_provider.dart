import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/repositories/auth_repository.dart';

final userStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
