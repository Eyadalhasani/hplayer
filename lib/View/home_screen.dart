import 'package:flutter/material.dart';
import 'package:hplayer/View/playlist.dart';
import 'package:hplayer/View/setting_screen.dart';
import 'package:hplayer/View/songs/main_audio_screen.dart';
import 'package:hplayer/View/videos/videos_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DefaultTabController? tabController;
  PageController? pageController = PageController(initialPage: 0);
  int mainIndex = 0;
  List<Widget> pages = const [
    VideosMainScreen(),
    MainAudioScreen(),
    PlaylistScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: mainIndex,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('H Player'),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (currentIndex) {
            setState(() {
              mainIndex = currentIndex;
            });
          },
          children: pages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(9),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 3))
                ],
            ),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Videos Side
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainIndex = 0;
                      pageController?.animateToPage(mainIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.elasticOut);
                    });
                  },
                  icon: Icon(
                    Icons.video_collection,
                    color: mainIndex == 0
                        ? Colors.white38
                        : Colors.black12,
                    size: 24,
                  ),
                ),
                //Songs Side
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        mainIndex = 1;
                        pageController?.animateToPage(mainIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.music_note,
                    color: mainIndex == 1
                        ? Colors.white38
                        : Colors.black12,
                    size: 24,
                  ),
                ),
                //Playlist Side
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        mainIndex = 2;
                        pageController?.animateToPage(mainIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.playlist_play_rounded,
                    color: mainIndex == 2
                        ? Colors.white38
                        : Colors.black12,
                    size: 35,
                  ),
                ),
                //Setting Side
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        mainIndex = 3;
                        pageController?.animateToPage(mainIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    color: mainIndex == 3
                        ? Colors.white38
                        : Colors.black12,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
