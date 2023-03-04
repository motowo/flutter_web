import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/models/card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../models/comment_model.dart';
import '../models/login_user.dart';
import '../providers/login_user_provider.dart';
import '../repositories/cards_repository.dart';

class CardDetailPage extends HookConsumerWidget {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid = ModalRoute.of(context)!.settings.arguments as String;
    final loginUser = ref.watch(loginUserStateProvider);
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
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () async {
                  logger.info("redy upload");
                  Uint8List? uint8list = await ImagePickerWeb.getImageAsBytes();
                  if (uint8list != null) {
                    var metadata = SettableMetadata(
                      contentType: "image/jpeg",
                    );
                    logger.info("start upload");
                    int unixtime = DateTime.now().microsecondsSinceEpoch;
                    UploadTask task = FirebaseStorage.instance
                        .ref("${uid}/${unixtime}")
                        .putData(uint8list, metadata);
                    task.snapshotEvents
                        .listen((TaskSnapshot taskSnapshot) async {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          final progress = 100.0 *
                              (taskSnapshot.bytesTransferred /
                                  taskSnapshot.totalBytes);
                          logger.info("Upload is $progress% complete.");
                          break;
                        case TaskState.paused:
                          logger.info("Upload is paused.");
                          break;
                        case TaskState.canceled:
                          logger.info("Upload was canceled");
                          break;
                        case TaskState.error:
                          logger.info("Upload was error");
                          break;
                        case TaskState.success:
                          String url = await taskSnapshot.ref.getDownloadURL();
                          ref.watch(cardsRepositoryProvider).addImage(
                              uid,
                              CommentModel(
                                  imageUrl: url,
                                  postedUid: loginUser!.user!.uid,
                                  postedUserType: loginUser.userType));
                          logger.info("Upload was completed: $url");
                          break;
                      }
                    });
                  }
                },
                child: Icon(Icons.upload),
              ),
            ),
            _commentInput(ref, uid, loginUser!),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('cards')
                    .doc(uid)
                    .collection('comments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        documents = snapshot.data!.docs.cast<
                            QueryDocumentSnapshot<Map<String, dynamic>>>();
                    return ListView(
                      children: documents.map((doc) {
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              children: [
                                Text("${doc['comment']}"),
                                doc.data().containsKey('imageUrl') &&
                                        doc['imageUrl'] != ""
                                    ? Image.network(doc['imageUrl'])
                                    : Container()
                              ],
                            ));
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

  Widget _commentInput(WidgetRef ref, String uid, LoginUser loginUser) {
    final commentController = useTextEditingController(text: '');
    return Container(
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
                      postedUid: loginUser.user!.uid,
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
    );
  }
}
