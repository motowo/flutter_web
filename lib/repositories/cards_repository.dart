import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/firebase_provider.dart';
import '../models/login_user.dart';

abstract class BaseCardsRepository {
  Future<void> addCard(String type, String status, String company);
}

final cardsRepositoryProvider =
    Provider<CardsRepository>((ref) => CardsRepository(ref));

class CardsRepository implements BaseCardsRepository {
  final Ref _ref;
  final String _collectionName = 'cards';

  const CardsRepository(this._ref);

  @override
  Future<void> addCard(String type, String status, String company) async {
    var doc = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .add({
      'type': type,
      'status': status,
      'company': company,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now()
    });
    logger.fine(doc);
  }
}
