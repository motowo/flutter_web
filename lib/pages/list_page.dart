import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web/pages/card_detail_page.dart';
import 'package:flutter_web/pages/login_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import '../providers/login_user_provider.dart';
import 'card_add_page.dart';

class ListPage extends HookConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserStateProvider);
    logger.fine(loginUser);
    return Scaffold(
        appBar: AppBar(
          title: Text('List'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                ref.read(authControllerProvider.notifier).signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                  'ログイン情報：${loginUser?.user?.email}, ${loginUser?.userType}, ${loginUser?.organization}'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(128, 32)),
              ),
              onPressed: () async {
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CardAddPage()),
                );
              },
              child: const Text('カード追加'),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cards')
                      .where('company', isEqualTo: loginUser?.organization)
                      .orderBy('updatedAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // データが取得できた場合
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      // 取得した投稿メッセージ一覧を元にリスト表示
                      return ListView(
                        children: documents.map((doc) {
                          return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        settings:
                                            RouteSettings(arguments: doc.id),
                                        builder: (context) =>
                                            const CardDetailPage()),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 64.0,
                                        width: 100.0,
                                        decoration:
                                            BoxDecoration(color: Colors.red),
                                        // type
                                        child: Text(doc['type'],
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              // id
                                              child: Text(doc.id),
                                            ),
                                            Container(
                                              // updatedAt
                                              child: Text(doc['updatedAt']
                                                  .toDate()
                                                  .toString()),
                                              // child: Text("aaa"),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 64.0,
                                        width: 100.0,
                                        decoration:
                                            BoxDecoration(color: Colors.blue),
                                        // type
                                        child: Text(
                                          doc['status'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }).toList(),
                      );
                    }
                    // データが読込中の場合
                    return const Center(
                      child: Text('読込中...'),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
