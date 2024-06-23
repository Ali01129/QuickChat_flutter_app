import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/auth/auth_service.dart';
import 'package:quickchat/chat/chat_services.dart';
import 'package:quickchat/components/chat_bubble.dart';
import 'package:quickchat/components/my_input_field.dart';

final ChatServices _chatServices = ChatServices();
final AuthService _authService = AuthService();

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverName;
  final String recieverID;

  ChatPage({super.key, required this.recieverEmail, required this.recieverName, required this.recieverID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        Future.delayed(
            const Duration(milliseconds: 500),()=>scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),()=>scrollDown(),
    );
  }
  @override
  void dispose() {
    // Dispose of the FocusNode to avoid memory leaks
    myFocusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }
  final ScrollController _scrollController=ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastEaseInToSlowEaseOut
    );
  }

  // Send message
  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.recieverID, _msgController.text);
      _msgController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recieverName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.purple),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // All messages
          Expanded(child: buildMsgList()),
          // Send message
          buildUserInput(),
        ],
      ),
    );
  }

  Widget buildMsgList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(senderID, widget.recieverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => buildMsgItem(doc)).toList(),
        );
      },
    );
  }

  Widget buildMsgItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return ListTile(
      title: Container(
        alignment: alignment,
        child: ChatBubble(
          message: data['message'],
          isCurrentUser: isCurrentUser,
        ),
      ),
    );
  }

  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              label: "Type a message",
              obscureText: false,
              controller: _msgController,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow.shade700,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.all(10),
            child: IconButton(
              onPressed: sendMsg,
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
