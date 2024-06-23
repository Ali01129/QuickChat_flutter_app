import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;
  Message({
    required this.senderID,
    required this.timestamp,
    required this.message,
    required this.recieverID,
    required this.senderEmail
  });
  Map<String,dynamic> toMap(){
    return{
      'senderID':senderID,
      'senderEmail':senderEmail,
      'recieverID':recieverID,
      'message':message,
      'timestamp':timestamp
    };
  }
}