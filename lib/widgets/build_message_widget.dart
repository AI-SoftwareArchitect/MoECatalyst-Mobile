import 'package:flutter/material.dart';
import '../models/message.dart';

Widget buildMessage(Message message,BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser ? Color(0xFF2563EB) : Color(0xFF374151),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}