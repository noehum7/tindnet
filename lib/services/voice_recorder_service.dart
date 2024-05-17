import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

/*
Clase donde se maneja el envio de audios en el chat
 */
class VoiceRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  String _filePath = ''; // Define la ruta del archivo de audio aquí

  VoiceRecorder() {
    _init();
  }

  Future<void> _init() async {
    _audioRecorder = FlutterSoundRecorder();
    // await _audioRecorder!.openRecorder();
  }

  Future<void> startRecording() async {
    if (_audioRecorder == null) {
      await _init();
    }

    if (_audioRecorder!.isStopped) {
      await _audioRecorder!.openRecorder();
    }

    Directory tempDir = await getTemporaryDirectory();
    _filePath = join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.aac');
    await _audioRecorder!.startRecorder(toFile: _filePath);
    _isRecording = true;
  }

  Future<String> stopRecording() async {
    await _audioRecorder!.stopRecorder();
    if (!_audioRecorder!.isStopped) {
      await _audioRecorder!.closeRecorder();
    }
    _isRecording = false;

    // Verifica si el archivo existe
    checkFileExists(_filePath);

    return _filePath;
  }

  bool get isInitialized {
    return _audioRecorder != null;
  }

  bool get isRecording {
    return _isRecording;
  }


  // Función para verificar si un archivo existe
  void checkFileExists(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      print('El archivo existe en la ruta especificada.');
    } else {
      print('El archivo no existe en la ruta especificada.');
    }
  }
}