import 'package:equalizer_flutter_custom/equalizer_flutter_custom.dart';
import'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
class EqualizerScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const EqualizerScreen({super.key, required this.audioPlayer});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomEqualizer(
        isEqEnabled: true,
        playerSessionId:
        widget.audioPlayer.androidAudioSessionId!,
        bandTextColor: Colors.white10,
        sliderBoxHeight: 220,
        sliderBoxPadding: 10,
        appbarElevation: 0,
        appBarShadowColor: Colors.white38,
        titleTextStyle:
        const TextStyle(color: Colors.grey),
        sliderBoxBorderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
