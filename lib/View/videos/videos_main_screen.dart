import 'package:flutter/material.dart';
class VideosMainScreen extends StatefulWidget {
  const VideosMainScreen({super.key});

  @override
  State<VideosMainScreen> createState() => _VideosMainScreenState();
}

class _VideosMainScreenState extends State<VideosMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [Center(child:Text('Videos',style: TextStyle(color: Colors.black,fontSize: 20),))],);
  }
}
