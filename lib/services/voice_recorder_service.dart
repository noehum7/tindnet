import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

/*
  Clase `VoiceRecorder` que maneja la grabación de audios en el chat.
  Proporciona métodos para:
    - Iniciar la grabación: `startRecording` inicia la grabación de un audio y guarda el archivo en una ruta temporal.
    - Detener la grabación: `stopRecording` detiene la grabación del audio y devuelve la ruta del archivo de audio.
    - Verificar si el grabador está inicializado: `isInitialized` devuelve un booleano que indica si el grabador está inicializado.
    - Verificar si se está grabando: `isRecording` devuelve un booleano que indica si se está grabando un audio.
 */

class VoiceRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  String _filePath = '';

  VoiceRecorder() {
    _init();
  }

  Future<void> _init() async {
    _audioRecorder = FlutterSoundRecorder();
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

    return _filePath;
  }

  bool get isInitialized {
    return _audioRecorder != null;
  }

  bool get isRecording {
    return _isRecording;
  }

}