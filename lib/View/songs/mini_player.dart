import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
        color: Colors.blueGrey,
        child:const Row(
          children: [
          CircleAvatar(child: Icon(Icons.close_rounded)),
          ],
        ),
    );
  }
}
