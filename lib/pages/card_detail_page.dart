import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/models/card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/comment_model.dart';
import '../providers/login_user_provider.dart';
import '../repositories/cards_repository.dart';

class CardDetailPage extends HookConsumerWidget {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid = ModalRoute.of(context)!.settings.arguments as String;
    final loginUser = ref.watch(loginUserStateProvider);
    final commentController = useTextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
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
                    return Column(
                      children: [
                        Text("type: ${card.type}"),
                        Text("status: ${card.status}"),
                        Text("company ${card.company}"),
                      ],
                    );
                  } else {
                    return Text('読込中 : $uid');
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add_comment),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      ref.watch(cardsRepositoryProvider).addComment(
                          uid,
                          CommentModel(
                              comment: commentController.text,
                              postedUid: loginUser!.user!.uid,
                              postedUserType: loginUser.userType));
                      commentController.clear();
                    },
                  ),
                  label: Text('コメント'),
                  hintText: 'よろしくおねがいします',
                ),
                controller: commentController,
                keyboardType: TextInputType.text,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cards')
                    .doc(uid)
                    .collection('comments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView(
                      children: documents.map((doc) {
                        logger.info("comment id = ${doc.id}");
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Text("${doc.id}, ${doc['comment']}"));
                      }).toList(),
                    );
                  } else {
                    return const Text('読込中...');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
