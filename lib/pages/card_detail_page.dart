import 'package:flutter/material.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({super.key});

  @override
  State createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[Text('CardDetail')],
          ),
        ),
      ),
    );
  }
}
