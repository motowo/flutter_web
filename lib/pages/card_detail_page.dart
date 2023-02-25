import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardDetailPage extends HookConsumerWidget {
  const CardDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Object? args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('detail'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[Text('CardDetail ${args as String}')],
          ),
        ),
      ),
    );
  }
}
