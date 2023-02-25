import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const CommentModel._();
  const factory CommentModel({
    required String comment,
    required String postedUid,
    required String postedUserType,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
  factory CommentModel.fromJsonStr(String jsonStr) =>
      _$CommentModelFromJson(json.decode(jsonStr));

  String toJsonStr() {
    return json.encode(toJson());
  }
}
