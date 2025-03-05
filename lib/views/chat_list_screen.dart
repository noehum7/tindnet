import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';
import '../widgets/custom_drawer_customer.dart';
import '../widgets/custom_drawer_business.dart';
import 'chat_screen.dart';

/*
 * `ChatListScreen` es una clase que representa la pantalla con la lista de chats del usuario.
 * Los chats se recuperan de Firestore y se muestran en una lista.
 * Al tocar un ListTile, se navega a la pantalla de chat correspondiente.
 * Al deslizar un ListTile, se elimina el chat correspondiente de Firestore.
 *
 * Esta clase utiliza `ChatService` para recuperar y eliminar chats.
 */

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
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text(
                        'No has iniciado ningún chat con las empresas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.grey)
                      ),
                    ],
                  ),
                );
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
                      String text = lastMessage != null ? lastMessage['text'] ?? '' : '';
                      Timestamp? timestamp = lastMessage != null ? lastMessage['timestamp'] : null;
                      String time = timestamp != null
                          ? DateFormat('Hm').format(timestamp.toDate())
                          : '';
                      bool isAudioMessage = lastMessage['text'].startsWith('https://firebasestorage.googleapis.com/');
                      bool isImageMessage = lastMessage['text'].startsWith('IMAGE');
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
                          // subtitle: Text(text),
                          subtitle: isAudioMessage
                              ? Row(
                                  children: [
                                    Icon(Icons.mic),
                                    SizedBox(width: 5),
                                    Text('Mensaje de voz'),
                                  ],
                                )
                              : isImageMessage
                                  ? Row(
                                      children: [
                                        Icon(Icons.image),
                                        SizedBox(width: 5),
                                        Text('Imagen'),
                                      ],
                                    )
                              : Text(text),
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
