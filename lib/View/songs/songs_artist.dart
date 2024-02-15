import 'package:flutter/material.dart';
import 'package:hplayer/model/songs_viwer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsArtist extends StatelessWidget {
  final OnAudioQuery audioQuery;
  final AudioPlayer audioPlayer;

  const SongsArtist({
    super.key,
    required this.audioQuery,
    required this.audioPlayer,
  });

  Future<List<String>> fetchArtistFolders() async {
    final songs = await audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    final artistFolders = <String>[];

    for (final song in songs) {
      final artist = song.artist;
      if (artist != null && !artistFolders.contains(artist)) {
        artistFolders.add(artist);
      }
    }

    return artistFolders;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<String>>(
        future: fetchArtistFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final artistFolders = snapshot.data ?? [];
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
                        const Text(
                          'Count: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          snapshot.data!.length.toString(),
                          style: const TextStyle(color: Colors.black),
                        )
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
                  itemCount: artistFolders.length,
                  itemBuilder: (context, index) {
                    final artistFolder = artistFolders[index];
                    return Card(
                      margin: const EdgeInsets.all(6),
                      child: ListTile(
                        title: Text(artistFolder),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongViewerScreen(
                                folderPath: artistFolder,
                                filterType: FilterType.artist,
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
