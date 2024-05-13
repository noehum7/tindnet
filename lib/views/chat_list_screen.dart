import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';
import '../widgets/custom_drawer_customer.dart';
import '../widgets/custom_drawer_business.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser == null) {
    //   return Center(child: Text('Por favor, inicia sesión'));
    // }
    String? userId = currentUser?.uid;

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Chats'),
    //     toolbarHeight: MediaQuery.of(context).size.height * 0.07,
    //   ),
    //   drawer: CustomDrawerCustomer(currentPage: 'Chats'),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: _chatService.getUserChats(userId!),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       return ListView.builder(
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           DocumentSnapshot chat = snapshot.data!.docs[index];
    //           return Dismissible(
    //             key: Key(chat.id),
    //             direction: DismissDirection.endToStart,
    //             onDismissed: (direction) {
    //               _chatService.deleteChat(chat.id);
    //             },
    //             background: Container(
    //               color: Colors.red,
    //               child: Icon(Icons.delete, color: Colors.white),
    //               alignment: Alignment.centerRight,
    //               padding: EdgeInsets.only(right: 20),
    //             ),
    //             child: ListTile(
    //               title: Text(chat['businessName']), // Asegúrate de tener el nombre de la empresa en el documento del chat
    //               onTap: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => ChatScreen(
    //                       chatId: chat.id,
    //                       userId: userId,
    //                       businessId: chat['businessId'], // Pasa businessId como argumento
    //                       businessName: chat['businessName'], // Pasa businessName como argumento
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
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
          drawer: isCustomer ? CustomDrawerCustomer(currentPage: 'Chats') : CustomDrawerBusiness(currentPage: 'Chats'),
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
                      // title: Text(chat['businessName']),
                      title: Text(isCustomer ? chat['businessName'] : chat['userName']), // Asegúrate de tener el nombre de la empresa en el documento del chat
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: chat.id,
                              userId: userId,
                              businessId: chat['businessId'],
                              businessName: chat['businessName'],
                              userName: chat['userName'], //AÑADIDO ESTO
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
          ),
        );
      },
    );
  }
}

