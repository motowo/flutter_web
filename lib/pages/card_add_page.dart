import 'package:flutter/material.dart';
import 'package:flutter_web/pages/card_detail_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/login_user_provider.dart';
import '../repositories/cards_repository.dart';

class CardAddPage extends HookConsumerWidget {
  const CardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(128, 32)),
                  ),
                  onPressed: () async {
                    ref
                        .watch(cardsRepositoryProvider)
                        .addCard('new', 'draft', loginUser!.organization);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const CardDetailPage()),
                    );
                  },
                  child: const Text('追加する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
