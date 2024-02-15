import 'package:equalizer_flutter_custom/equalizer_flutter_custom.dart';
import 'package:flutter/material.dart';
import 'package:hplayer/View/home_screen.dart';
import 'package:hplayer/config/const/themes.dart';
import 'package:hplayer/config/handler/permissions_handler.dart';
import 'package:hplayer/config/provider/song_model_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(create: (context)=>SongModelProvider(),child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkPermission(),
      builder: (context,snapshot) {
        if(snapshot.hasError){
          return const  Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator(),)),);
        }
        else {
          return ChangeNotifierProvider(
            create:(context)=>EqualizerProvider() ,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'H Player',
              theme: lightTheme,
              home:const HomeScreen(),
            ),
          );
        }
      }
    );
  }
}