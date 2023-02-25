// import 'package:flutter/foundation.dart' show immutable;

// @immutable
// class Card {
//   const Card({required this.type, required this.status, required this.company});
//   final String type;
//   final String status;
//   final String company;
//   // final String uid;
//   @override
//   String toString() {
//     return '$type, $status, $company';
//   }
// }

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
class Card with _$Card {
  const factory Card(
      {required String type,
      required String status,
      required String company}) = _Card;

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
  factory Card.fromJsonStr(String jsonStr) =>
      _$CardFromJson(json.decode(jsonStr));

  String toJsonStr() {
    return json.encode(toJson());
  }
}
