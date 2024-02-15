import 'package:flutter/material.dart';
import 'package:hplayer/View/songs/audio_main_player.dart';
import 'package:hplayer/config/handler/delete_handler.dart';
import 'package:hplayer/config/handler/share_handler.dart';
import 'package:hplayer/config/provider/song_model_provider.dart';
import 'package:hplayer/model/song_details.dart';
import 'package:hplayer/model/song_main_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

enum FilterType {
  folder,
  artist,
  album,
}

class SongViewerScreen extends StatefulWidget {
  final String folderPath;
  final FilterType filterType;
  final AudioPlayer audioPlayer;
  final OnAudioQuery audioQuery;

  const SongViewerScreen({
    super.key,
    required this.folderPath,
    required this.audioPlayer,
    required this.audioQuery,
    required this.filterType,
  });

  @override
  _SongViewerScreenState createState() => _SongViewerScreenState();
}

class _SongViewerScreenState extends State<SongViewerScreen> {
  late Future<List<SongModel>> _songsFuture;
  bool isIndexSelected = false;
  bool isCheckable = false;
  Set<int> selectedIndexes = {};
  String count = '0';
  DeleteHandler deleteHandler = DeleteHandler()
  ;

  @override
  void initState() {
    super.initState();
    _songsFuture = fetchSongs(widget.filterType);
  }

  Future<List<SongModel>> fetchSongs(FilterType filterType) async {
    final songs = await widget.audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.DISPLAY_NAME,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> filteredSongs;

    switch (filterType) {
      case FilterType.folder:
        filteredSongs = songs.where((song) {
          return song.data.contains(widget.folderPath);
        }).toList();
        break;
      case FilterType.artist:
        filteredSongs = songs.where((song) {
          return song.artist == widget.folderPath;
        }).toList();
        break;
      case FilterType.album:
        filteredSongs = songs.where((song) {
          return song.album == widget.folderPath;
        }).toList();
        break;
    }

    return filteredSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('H Player'),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _songsFuture,
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
              ),
            );
          }
          final songs = snapshot.data ?? [];
          count = isCheckable
              ? selectedIndexes.length.toString()
              : snapshot.data!.length.toString();
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(2),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Container(
                      margin: const EdgeInsets.all(6),
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isCheckable = true;
                            selectedIndexes.add(index);
                          });
                        },
                        child: isCheckable
                            ? CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: selectedIndexes.contains(index),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      if (value!) {
                                        selectedIndexes.add(index);
                                      } else {
                                        selectedIndexes.remove(index);
                                      }

                                      //If there is nothing selected selection will be removed directly
                                      if (!selectedIndexes.isNotEmpty) {
                                        isCheckable = false;
                                      }
                                    },
                                  );
                                },
                                title: ListTile(
                                  style: Theme.of(context).listTileTheme.style,
                                  // leading: QueryArtworkWidget(
                                  //   id: song.data![index].id,
                                  //   type: ArtworkType.AUDIO,
                                  //   nullArtworkWidget: const Icon(Icons.music_note),
                                  // ),
                                  title: Text(
                                    song.displayNameWOExt,
                                    maxLines: 1,

                                  ),
                                  subtitle: Text(
                                    song.artist.toString() == "<unknown>"
                                        ? "Unknown"
                                        : song.artist.toString(),
                                  ),
                                  //Selections When Checkable list Enabled
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'selection_') {
                                        setState(
                                          () {
                                            if (isCheckable) {
                                              isCheckable = false;
                                            } else {
                                              isCheckable = true;
                                            }
                                            selectedIndexes.add(index);
                                          },
                                        );
                                      } else if (value == 'sharing') {
                                        List<songMainData> songdata = [];
                                        for (final songIndex
                                            in selectedIndexes) {
                                          songdata.add(songMainData(
                                            songs[songIndex].uri!,
                                            songs[songIndex].displayNameWOExt,
                                            songs[songIndex].fileExtension,
                                          ));
                                        }
                                        shareFile(
                                            multiShare: true,
                                            songList: songdata);
                                      }
                                      else if(value == 'delete'){

                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'selection_',
                                        child: Text('Select'),
                                      ),
                                      PopupMenuItem(
                                        value: 'sharing',
                                        child: Text('Share'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (!isCheckable) {
                                      setState(
                                        () {
                                          context
                                              .read<SongModelProvider>()
                                              .setId(song.id);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AudioMainPlayer(
                                                songData: songs,
                                                index: index,
                                                audioPlayer: widget.audioPlayer,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        if (selectedIndexes.contains(index)) {
                                          selectedIndexes.remove(index);
                                        } else {
                                          selectedIndexes.add(index);
                                        }
                                      });
                                    }
                                  },
                                ),
                              )
                            : ListTile(
                                leading: QueryArtworkWidget(
                                  id: song.id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note),
                                ),
                                title: Text(
                                  song.displayNameWOExt,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                subtitle: Text(
                                  song.artist.toString() == "<unknown>"
                                      ? "unknown"
                                      : song.artist.toString() == 'null'
                                          ? 'unknown'
                                          : song.artist.toString(),
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'selection_') {
                                      setState(
                                        () {
                                          if (isCheckable) {
                                            isCheckable = false;
                                          } else {
                                            isCheckable = true;
                                          }
                                          selectedIndexes.add(index);
                                        },
                                      );
                                    } else if (value == 'sharing') {
                                      shareFile(
                                        uri: song.uri!,
                                        fileName: song.displayNameWOExt,
                                        fileExtension: song.fileExtension,
                                        multiShare: false,
                                      );
                                    } else if (value == 'information') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SongDetailsDialog(
                                            songData: song,
                                          );
                                        },
                                      );
                                    }
                                    else if (value == 'delete') {
                                      deleteHandler.getDeletingFilesPath(songData: [songMainData(song.uri!, '', '')],multiDelete: false);
                                      setState(() {

                                      });
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'selection_',
                                      child: Text('Select'),
                                    ),
                                    PopupMenuItem(
                                      value: 'sharing',
                                      child: Text('Share'),
                                    ),
                                    PopupMenuItem(
                                      value: 'information',
                                      child: Text('Details'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(
                                    () {
                                      context
                                          .read<SongModelProvider>()
                                          .setId(song.id);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AudioMainPlayer(
                                            songData: songs,
                                            index: index,
                                            audioPlayer: widget.audioPlayer,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    );
                  },
                ),

                // ), ListView.builder(
                //   itemCount: songs.length,
                //   itemBuilder: (context, index) {
                //     final song = songs[index];
                //     return Container(
                //       margin: const EdgeInsets.all(6),
                //       child: ListTile(
                //         leading: QueryArtworkWidget(
                //           id: song.id,
                //           type: ArtworkType.AUDIO,
                //           nullArtworkWidget: const Icon(Icons.music_note),
                //         ),
                //         title: Text(
                //           song.displayNameWOExt,
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //         subtitle: Text(song.artist ?? 'unknown Artist'),
                //         onTap: () {
                //           // Play the song using the audioPlayer
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => AudioMainPlayer(
                //                 songData: songs,
                //                 index: index,
                //                 audioPlayer: widget.audioPlayer,
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //     );
                //   },
                // ),
              ),
            ],
          );
        },
      ),
    );
  }
}
