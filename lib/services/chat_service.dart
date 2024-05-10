import 'package:cloud_firestore/cloud_firestore.dart';

/*
  ChatService se encarga de todas las interacciones con Firestore relacionadas con el chat.
  Iniciar chats, obtener lista de chats, enviar mensajes y escuchar los mensajes de un chat.
 */

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> startChat(String userId, String businessId, String businessName) async {
    String chatId = '$userId-$businessId'; // Genera un chatId único
    DocumentSnapshot chatSnapshot = await _firestore.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists) {
      // Si el chat no existe, crea uno nuevo
      return _firestore.collection('chats').doc(chatId).set({
        'participants': [userId, businessId],
        'businessId': businessId, // Almacena businessId en el documento del chat
        'businessName': businessName, // Almacena businessName en el documento del chat
      });
    }
  }

  Future<void> sendMessage(String chatId, String userId, String text) {
    return _firestore.collection('chats').doc(chatId).collection('messages').add({
      'text': text,
      'sentBy': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteChat(String chatId) async {
    // Primero, obtén una referencia al chat
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);

    // Luego, obtén todos los mensajes del chat
    QuerySnapshot messagesSnapshot = await chatRef.collection('messages').get();

    // Después, para cada mensaje en el chat, elimínalo
    for (DocumentSnapshot message in messagesSnapshot.docs) {
      await chatRef.collection('messages').doc(message.id).delete();
    }

    // Finalmente, elimina el chat
    await chatRef.delete();
  }

  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore.collection('chats').where('participants', arrayContains: userId).snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) async* {
    DocumentSnapshot chatSnapshot = await _firestore.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
      // Si el chat existe, obtiene sus mensajes
      yield* _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      // Si el chat no existe, devuelve un Stream vacío
      yield* Stream<QuerySnapshot>.empty();
    }
  }
}