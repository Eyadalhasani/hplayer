import 'package:flutter/material.dart';
class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [Center(child:Text('Playlist',style: TextStyle(color:Colors.black,fontSize: 20),))],);

  }
}
