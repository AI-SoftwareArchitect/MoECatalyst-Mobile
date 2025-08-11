import 'package:flutter/material.dart';

Widget buildWelcomeMessage() {
  return Container(
    padding: EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'MoECatalyst\'e Hoş Geldiniz!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          'Benimle sohbet etmek için aşağıdaki alana mesajınızı yazın.',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFD1D5DB),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
