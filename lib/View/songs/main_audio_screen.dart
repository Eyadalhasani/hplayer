import 'package:flutter/material.dart';
import 'package:hplayer/View/songs/all_song.dart';
import 'package:hplayer/View/songs/songs_album.dart';
import 'package:hplayer/View/songs/songs_artist.dart';
import 'package:hplayer/View/songs/songs_folder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainAudioScreen extends StatefulWidget {
  const MainAudioScreen({super.key});

  @override
  State<MainAudioScreen> createState() => _MainAudioScreenState();
}

class _MainAudioScreenState extends State<MainAudioScreen> {
  TabController? tabController;
  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  int currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      AllSongs(audioPlayer: audioPlayer, audioQuery: audioQuery),
      SongsFolder(audioPlayer: audioPlayer, audioQuery: audioQuery),
      SongsArtist(audioQuery: audioQuery, audioPlayer: audioPlayer),
      SongsAlbums(audioQuery: audioQuery, audioPlayer: audioPlayer),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
     onPopInvoked: (value){
       currentIndex = 0;
     },
      child: DefaultTabController(
        initialIndex: currentIndex,
        length: 4,
        child: Column(
          children: [
            //This Container to make it easy for user to swap between main tap bar and this tap bar
            Container(height: 15, color: Colors.white),
            Expanded(
              flex: 0,
              child: Container(
                color: Colors.white,
                child: TabBar(
                  tabs: const [
                    Text('Songs'),
                    Text('Folders'),
                    Text('Artists'),
                    Text('Albums'),
                  ],
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: tabController,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
