import 'package:flutter/material.dart';
import 'package:moe_catalyst_flutter/pages/chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoECatalyst Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}