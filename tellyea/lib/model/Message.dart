import 'package:flutter/cupertino.dart';

class Message {
  Message({
    @required this.chatID,
    @required this.dateTime,
    @required this.message,
    @required this.messageSeen,
    @required this.receiver,
    @required this.sender,
  });
  final String chatID;
  final String sender; // both in ownerid
  final String receiver;
  final String message; // as text in database
  final DateTime dateTime;
  final bool messageSeen;
}
