import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_provider.dart';

class ListPage extends HookConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('List ${user?.email}'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                ref.read(authControllerProvider.notifier).signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Text('ログイン情報：${user?.email}'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // 投稿メッセージ一覧を取得（非同期処理）
                // 投稿日時でソート
                stream: FirebaseFirestore.instance
                    .collection('cards')
                    .where('company', isEqualTo: 'a')
                    .orderBy('updatedAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  // データが取得できた場合
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    // 取得した投稿メッセージ一覧を元にリスト表示
                    return ListView(
                      children: documents.map((doc) {
                        return Card(
                          child: ListTile(
                            title: Text(doc.id),
                            subtitle: Text(doc['status']),
                          ),
                        );
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
          ],
        ));
  }
}
