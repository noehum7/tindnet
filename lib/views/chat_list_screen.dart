import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';
import '../widgets/custom_drawer_customer.dart';
import '../widgets/custom_drawer_business.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        bool isCustomer = snapshot.data!.exists;
        return Scaffold(
          appBar: AppBar(
            title: Text('Chats'),
            toolbarHeight: MediaQuery.of(context).size.height * 0.07,
          ),
          drawer: isCustomer
              ? CustomDrawerCustomer(currentPage: 'Chats')
              : CustomDrawerBusiness(currentPage: 'Chats'),
          body: StreamBuilder<QuerySnapshot>(
            stream: _chatService.getUserChats(userId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot chat = snapshot.data!.docs[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: _chatService.getLastMessage(chat.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      DocumentSnapshot lastMessage = snapshot.data!;
                      // String text = lastMessage['text'] ?? '';
                      String text = lastMessage != null ? lastMessage['text'] ?? '' : '';
                      // Timestamp? timestamp = lastMessage['timestamp'];
                      Timestamp? timestamp = lastMessage != null ? lastMessage['timestamp'] : null;
                      String time = timestamp != null
                          ? DateFormat('Hm').format(timestamp.toDate())
                          : '';
                      return Dismissible(
                        key: Key(chat.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _chatService.deleteChat(chat.id);
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(isCustomer
                                ? chat['businessName'][0]
                                : chat['userName'][0]),
                          ),
                          title: Text(isCustomer
                              ? chat['businessName']
                              : chat['userName'], style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(text),
                          trailing: Text(time),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chat.id,
                                  userId: userId,
                                  businessId: chat['businessId'],
                                  businessName: chat['businessName'],
                                  userName: chat['userName'],
                                  isCustomer: isCustomer,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
