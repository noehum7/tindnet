import 'dart:io'; // Cambia esto
import 'package:path/path.dart'; // Añade esto
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*
  ChatService se encarga de todas las interacciones con Firestore relacionadas con el chat.
  Iniciar chats, obtener lista de chats, enviar mensajes y escuchar los mensajes de un chat.
 */

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> startChat(String userId, String businessId, String businessName, String userName, bool isCustomer) async {
    String chatId = '$userId-$businessId'; // Genera un chatId único
    DocumentSnapshot chatSnapshot = await _firestore.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists && isCustomer) {
      // Si el chat no existe y eres un cliente, crea uno nuevo
      return _firestore.collection('chats').doc(chatId).set({
        'participants': [userId, businessId],
        'businessId': businessId, // Almacena businessId en el documento del chat
        'businessName': businessName, // Almacena businessName en el documento del chat
        'userName': userName, // Almacena userName en el documento del chat
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

  Future<DocumentSnapshot> getLastMessage(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);
  }

  Future<String> uploadAudio(String filePath) async {
    File file = File(filePath);
    String fileName = basename(filePath); // Obtén el nombre del archivo de la ruta

    try {
      // Sube el archivo a Firebase Storage
      UploadTask task = FirebaseStorage.instance
          .ref('audio_messages/$fileName')
          .putFile(file);

      // Espera hasta que la tarea de subida se complete y obtén la URL de descarga
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }
}