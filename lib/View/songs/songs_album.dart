import 'package:flutter/material.dart';
import 'package:hplayer/model/songs_viwer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsAlbums extends StatelessWidget {
  final OnAudioQuery audioQuery;
  final AudioPlayer audioPlayer;

  const SongsAlbums({
    super.key,
    required this.audioQuery,
    required this.audioPlayer,
  });

  Future<List<String>> fetchAlbumFolders() async {
    final songs = await audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    final albumFolders = <String>[];

    for (final song in songs) {
      final album = song.album;
      if (album != null && !albumFolders.contains(album)) {
        albumFolders.add(album);
      }
    }

    return albumFolders;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<String>>(
        future: fetchAlbumFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black),
              ),
            );
          }
          final albumFolders = snapshot.data ?? [];
          return Column(
            children: [
              //Count Container
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Text('Count: ',
                            style: TextStyle(color: Colors.black)),
                        Text(snapshot.data!.length.toString(),
                            style: const TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: albumFolders.length,
                  itemBuilder: (context, index) {
                    final albumFolder = albumFolders[index];
                    return Card(
                      margin: const EdgeInsets.all(6),
                      child: ListTile(
                        // leading: QueryArtworkWidget(
                        //   id: albumFolder,
                        //   type: ArtworkType.ALBUM,
                        //   nullArtworkWidget: const Icon(Icons.music_note),
                        // ),
                        title: Text(albumFolder),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongViewerScreen(
                                folderPath: albumFolder,
                                filterType: FilterType.album,
                                audioQuery: audioQuery,
                                audioPlayer: audioPlayer,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
