import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tindnet/constants/app_colors.dart';
import '../services/chat_service.dart';
import 'package:intl/intl.dart';
import '../services/voice_recorder_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/audio_player_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String businessId;
  final String businessName;
  final String userName;
  final bool isCustomer;

  ChatScreen({
    required this.chatId,
    required this.userId,
    required this.businessId,
    required this.businessName,
    required this.userName,
    required this.isCustomer,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final VoiceRecorder _voiceRecorder = VoiceRecorder();

  Future<void> requestAudioPermission() async {
    PermissionStatus status = await Permission.microphone.status;

    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.microphone.request();
      if (!newStatus.isGranted) {
        // El usuario no concedió el permiso
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permiso denegado'),
              content: Text('Necesitamos el permiso del micrófono para grabar audio. Por favor, habilita el permiso en la configuración de la aplicación.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  bool _isRecording = false; // Añade un estado para la grabación


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded,
              color: AppColors.primaryColor,
              size: 40), // Cambia esto al ícono que prefieras
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.isCustomer ? widget.businessName : widget.userName),
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
                List<DocumentSnapshot> messages = snapshot.data!.docs.reversed
                    .toList(); // Invierte el orden de los mensajes
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot message = messages[index];
                    bool isUserMessage = message['sentBy'] == widget.userId;
                    Timestamp? timestamp = message['timestamp']; // Recupera la hora del mensaje
                    String time = timestamp != null ? DateFormat('Hm').format(timestamp.toDate()) : ''; // Formatea la hora
                    // Comprueba si el mensaje es un enlace de audio
                    bool isAudioMessage = message['text'].startsWith('https://firebasestorage.googleapis.com/');

                    return Container(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Hace que la fila ocupe el espacio mínimo necesario
                          children: <Widget>[
                            // ConstrainedBox(
                            //   constraints: BoxConstraints(
                            //     maxWidth: MediaQuery.of(context).size.width * 0.65,
                            //   ),
                            //   child: Text(
                            //     message['text'],
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.65,
                              ),
                              child: isAudioMessage
                                  ? AudioPlayerWidget(url: message['text']) // Si es un mensaje de audio, muestra el reproductor de audio
                                  : Text(
                                message['text'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10), // Añade un espacio entre el mensaje y la hora
                            Text(
                              time,
                              style: TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 70.0,
            // height: MediaQuery.of(context).size.height * 0.15,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (_isRecording)
                  IconButton(
                    icon: Icon(Icons.stop, color: Colors.red),
                    onPressed: () async {
                      if (_voiceRecorder.isRecording) {
                        String filePath = await _voiceRecorder.stopRecording();
                        if (File(filePath).existsSync()) {
                          String downloadUrl = await _chatService.uploadAudio(filePath);

                          // Envía la URL de descarga como un mensaje
                          _chatService.sendMessage(
                            widget.chatId,
                            widget.userId,
                            downloadUrl,
                          );
                        }
                      }
                      setState(() {
                        _isRecording = false;
                      });
                    },
                  )
                else
                  GestureDetector(
                    onTap: () async {
                      await requestAudioPermission();
                      if (_voiceRecorder.isInitialized) {
                        await _voiceRecorder.startRecording();
                        setState(() {
                          _isRecording = true;
                        });
                      }
                    },
                    child: Icon(Icons.mic),
                  ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primaryColor),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await _chatService.startChat(
                          widget.userId,
                          widget.businessId,
                          widget.businessName,
                          widget.userName,
                          widget.isCustomer
                      );

                      _chatService.sendMessage(
                        widget.chatId,
                        widget.userId,
                        _messageController.text,
                      );

                      _messageController.clear();
                      setState(() {}); // Forzar una actualización de la interfaz de usuario para mostrar los nuevos mensajes
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
