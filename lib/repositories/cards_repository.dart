import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/card.dart';
import '../providers/firebase_provider.dart';
import '../models/login_user.dart';

abstract class BaseCardsRepository {
  Future<void> addCard(Card card);
}

final cardsRepositoryProvider =
    Provider<CardsRepository>((ref) => CardsRepository(ref));

class CardsRepository implements BaseCardsRepository {
  final Ref _ref;
  final String _collectionName = 'cards';

  const CardsRepository(this._ref);

  @override
  Future<void> addCard(Card card) async {
    var toJson = card.toJson();
    toJson.addAll({'createdAt': DateTime.now(), 'updatedAt': DateTime.now()});
    var doc = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .add(toJson);
    logger.fine(doc);
  }
}
