import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/card_model.dart';
import '../models/comment_model.dart';
import '../providers/firebase_provider.dart';

abstract class BaseCardsRepository {
  Future<String> addCard(CardModel card);
  Future<CardModel> getCard(String uid);
  Future<String> addComment(String uid, CommentModel comment);
}

final cardsRepositoryProvider =
    Provider<CardsRepository>((ref) => CardsRepository(ref));

class CardsRepository implements BaseCardsRepository {
  final Ref _ref;
  final String _collectionName = 'cards';
  final String _commentsCollectionName = 'comments';
  final String _imagesCollectionName = 'images';

  const CardsRepository(this._ref);

  @override
  Future<String> addCard(CardModel card) async {
    var toJson = card.toJson();
    toJson.addAll({'createdAt': DateTime.now(), 'updatedAt': DateTime.now()});
    var doc = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .add(toJson);
    return doc.id;
  }

  @override
  Future<CardModel> getCard(String uid) async {
    var doc = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .doc(uid)
        .get();
    return CardModel.fromJson(doc as Map<String, dynamic>);
  }

  @override
  Future<String> addComment(String uid, CommentModel comment) async {
    var toJson = comment.toJson();
    toJson.addAll({'createdAt': DateTime.now()});
    var doc = await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .doc(uid)
        .collection(_commentsCollectionName)
        .add(toJson);
    await _ref
        .read(firebaseFirestoreProvider)
        .collection(_collectionName)
        .doc(uid)
        .set({"latestComment": comment.comment, "updatedAt": DateTime.now()},
            SetOptions(merge: true));
    return doc.id;
  }
}
