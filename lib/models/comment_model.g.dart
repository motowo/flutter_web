// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentModel _$$_CommentModelFromJson(Map<String, dynamic> json) =>
    _$_CommentModel(
      comment: json['comment'] as String,
      postedUid: json['postedUid'] as String,
      postedUserType: json['postedUserType'] as String,
    );

Map<String, dynamic> _$$_CommentModelToJson(_$_CommentModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'postedUid': instance.postedUid,
      'postedUserType': instance.postedUserType,
    };
