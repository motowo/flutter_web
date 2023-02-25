import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const CardModel._();
  const factory CardModel(
      {required String type,
      required String status,
      required String company}) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
  factory CardModel.fromJsonStr(String jsonStr) =>
      _$CardModelFromJson(json.decode(jsonStr));

  String toJsonStr() {
    return json.encode(toJson());
  }
}
