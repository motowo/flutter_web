import 'package:flutter/foundation.dart' show immutable;

@immutable
class Card {
  const Card({required this.type, required this.status, required this.company});
  final String type;
  final String status;
  final String company;
  // final String uid;
  @override
  String toString() {
    return '$type, $status, $company';
  }
}
