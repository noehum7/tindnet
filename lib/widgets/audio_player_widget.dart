import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

enum PlayerState { STOPPED, PLAYING, PAUSED }

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