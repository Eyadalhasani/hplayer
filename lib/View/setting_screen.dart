import 'package:flutter/material.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [Center(child:Text('Setting',style: TextStyle(color:Colors.black,fontSize: 20),))],);

  }
}
