import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/models/card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/cards_repository.dart';

class CardDetailPage extends HookConsumerWidget {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid = ModalRoute.of(context)!.settings.arguments as String;
    // CardModel card = await ref
    //                     .watch(cardsRepositoryProvider).getCard(uid)
    //                     ;
    return Scaffold(
      appBar: AppBar(
        title: Text('detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Container(
            child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('cards')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data?.data() as Map<String, dynamic>;
              logger.fine(data);
              CardModel card = CardModel.fromJson(data);
              return Container(
                child: Column(
                  children: [
                    Text("type: ${card.type}"),
                    Text("status: ${card.status}"),
                    Text("company ${card.company}")
                  ],
                ),
              );
            } else {
              return Container(
                child: Text('読込中 : $uid'),
              );
            }
          },
        )),
      ),
    );
  }
}
