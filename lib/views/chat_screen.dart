import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tindnet/constants/app_colors.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String businessId;
  final String businessName;

  ChatScreen({
    required this.chatId,
    required this.userId,
    required this.businessId,
    required this.businessName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.businessName),
      // ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: AppColors.primaryColor, size: 40), // Cambia esto al ícono que prefieras
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.businessName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getChatMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container();
                }
                List<DocumentSnapshot> messages = snapshot.data!.docs.reversed.toList(); // Invierte el orden de los mensajes
                return ListView.builder(
                  // itemCount: snapshot.data!.docs.length,
                  // itemBuilder: (context, index) {
                  //   DocumentSnapshot message = snapshot.data!.docs[index];
                  //   bool isUserMessage = message['sentBy'] == widget.userId;
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot message = messages[index];
                    bool isUserMessage = message['sentBy'] == widget.userId;
                    return Container(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Escribe un mensaje...',
            ),
          ),
          ElevatedButton(
            child: Text('Enviar'),
            onPressed: () async{
              if (_messageController.text.isNotEmpty) {
                await _chatService.startChat(
                  widget.userId,
                  widget.businessId,
                  widget.businessName,
                );
                _chatService.sendMessage(
                  widget.chatId,
                  widget.userId,
                  _messageController.text,
                );
                _messageController.clear();
                setState(() {}); // Forzar una actualización de la interfaz de usuario
              }
            },
          ),
        ],
      ),
    );
  }
}