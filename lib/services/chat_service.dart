import 'dart:io'; // Cambia esto
import 'package:path/path.dart'; // Añade esto
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*
  ChatService se encarga de todas las interacciones con Firestore relacionadas con el chat.
  Proporciona métodos para:
  - Iniciar chats: `startChat` crea un nuevo chat en Firestore entre un usuario y un negocio.
  - Enviar mensajes: `sendMessage` añade un nuevo mensaje a un chat específico en Firestore.
  - Eliminar chats: `deleteChat` elimina un chat y todos sus mensajes de Firestore. Esto tengo que retocarlo porque borra el chat tanto para el cliente como para la empresa.
  - Obtener chats de un usuario: `getUserChats` devuelve un Stream de QuerySnapshot que contiene todos los chats en los que participa un usuario específico.
  - Obtener mensajes de un chat: `getChatMessages` devuelve un Stream de QuerySnapshot que contiene todos los mensajes de un chat específico.
  - Obtener el último mensaje de un chat: `getLastMessage` devuelve un Future de DocumentSnapshot que contiene el último mensaje enviado en un chat específico.
  - Subir archivos de audio: `uploadAudio` sube un archivo de audio a Firebase Storage y devuelve la URL de descarga.
 */

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> startChat(String userId, String businessId, String businessName, String userName, bool isCustomer) async {
    String chatId = '$userId-$businessId'; // Genera un chatId único
    DocumentSnapshot chatSnapshot = await _firestore.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists && isCustomer) {
      // Si el chat no existe y eres un cliente, crea uno nuevo y lo guarda en la base de datos
      return _firestore.collection('chats').doc(chatId).set({
        'participants': [userId, businessId],
        'businessId': businessId,
        'businessName': businessName,
        'userName': userName,
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
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
    QuerySnapshot messagesSnapshot = await chatRef.collection('messages').get();

    for (DocumentSnapshot message in messagesSnapshot.docs) {
      await chatRef.collection('messages').doc(message.id).delete();
    }

    await chatRef.delete();
  }


  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore.collection('chats').where('participants', arrayContains: userId).snapshots();
  }


  Stream<QuerySnapshot> getChatMessages(String chatId) async* {
    DocumentSnapshot chatSnapshot = await _firestore.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
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
      return 'Error al subir el archivo de audio';
    }
  }
}