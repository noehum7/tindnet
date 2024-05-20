import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/*
  Enum `PlayerState` que representa los diferentes estados de un reproductor de audio: parado, reproduciendo y pausado.
 */
enum PlayerState { STOPPED, PLAYING, PAUSED }

/*
  Clase `AudioPlayerWidget` que reproduce un archivo de audio a partir de una URL y utiliza la biblioteca audioplayers para ello.
  Proporciona funcionalidades para:
   - Reproducir y pausar un audio: El botón de reproducción/pausa cambia su estado dependiendo de si el audio se está reproduciendo o no.
   - Manejar el final de la reproducción: Cuando el audio termina, el estado del reproductor vuelve a `STOPPED`.
   - Maneja los cambios de estado del reproductor de audio y actualiza la interfaz de usuario en consecuencia.
 */

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  AudioPlayerWidget({required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.STOPPED;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.STOPPED;
      });
    });

  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(_playerState == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
          onPressed: () async {
            if (_playerState == PlayerState.PLAYING) {
              await _audioPlayer.pause();
              setState(() {
                _playerState = PlayerState.PAUSED;
              });
            } else {
              await _audioPlayer.play(UrlSource(widget.url));
              setState(() {
                _playerState = PlayerState.PLAYING;
              });
            }
          },
        ),
      ],
    );
  }
}