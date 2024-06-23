import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickchat/models/message.dart';

class ChatServices{
  // 1-instance
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  // 2-users
  Stream<List<Map<String,dynamic>>> getUsers(){
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        final user=doc.data();
        return user;
      }).toList();
    });
  }

  // 3-send message
  Future<void> sendMessage(String receiverID,message)async{
    //user info
    final String currentUserID=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final  Timestamp timestamp=Timestamp.now();
    //create msg
    Message newMsg=Message(
        senderID: currentUserID,
        timestamp: timestamp,
        message: message,
        recieverID: receiverID,
        senderEmail: currentUserEmail,
    );
    //create chat room id
    List<String> ids=[currentUserID,receiverID];
    ids.sort();
    String chatRoomID=ids.join('_');
    //add new msg to database
    await _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMsg.toMap());
  }


  // 4-get messages
  Stream<QuerySnapshot> getMessages(String userID,otherUserID){
    List<String> ids=[userID,otherUserID];
    ids.sort();
    String chatRoomID=ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }
}