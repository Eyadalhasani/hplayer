import 'package:flutter/material.dart';
import 'package:hplayer/View/songs/audio_main_player.dart';
import 'package:hplayer/model/delete_dialog.dart';
import 'package:hplayer/config/handler/delete_handler.dart';
import 'package:hplayer/model/song_details.dart';
import 'package:hplayer/model/song_main_data.dart';
import 'package:hplayer/config/handler/share_handler.dart';
import 'package:hplayer/config/provider/song_model_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

var currentlyPlayingSong = '';

class AllSongs extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final OnAudioQuery audioQuery;

  const AllSongs(
      {super.key, required this.audioPlayer, required this.audioQuery});

  get song => null;

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  bool isIndexSelected = false;
  bool isCheckable = false;
  Set<int> selectedIndexes = {};
  String count = '0';
  DeleteHandler deleteHandler= DeleteHandler();
  //This to change the text color of playing song
  void setCurrentlyPlayingSong(String songName) {
    setState(() {
      currentlyPlayingSong = songName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<SongModel>>(
        future: widget.audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.DISPLAY_NAME,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, song) {
          if (song.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (song.hasError) {
            return Center(
              child: Text(
                "Error: ${song.error}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          } else if (song.data!.isEmpty) {
            return Center(
              child: Text(
                "No Song has been Found !!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          } else {
            count = isCheckable
                ? selectedIndexes.length.toString()
                : song.data!.length.toString();
            return Column(
              children: [
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
                            count,
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
                    itemCount: song.data!.length,
                    itemBuilder: (context, index) {
                      final String displayName =
                          song.data![index].displayNameWOExt;
                      final bool isCurrentlyPlaying =
                          displayName == currentlyPlayingSong;
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
                                    style:
                                        Theme.of(context).listTileTheme.style,
                                    // leading: QueryArtworkWidget(
                                    //   id: song.data![index].id,
                                    //   type: ArtworkType.AUDIO,
                                    //   nullArtworkWidget: const Icon(Icons.music_note),
                                    // ),
                                    title: Text(
                                      song.data![index].displayNameWOExt,
                                      maxLines: 1,
                                      style: isPlaying && isCurrentlyPlaying
                                          ? const TextStyle(color: Colors.blue)
                                          : null,
                                    ),
                                    subtitle: Text(
                                      song.data![index].artist.toString() ==
                                              "<unknown>"
                                          ? "Unknown"
                                          : song.data![index].artist.toString(),
                                    ),
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
                                              song.data![songIndex].uri!,
                                              song.data![songIndex]
                                                  .displayNameWOExt,
                                              song.data![songIndex]
                                                  .fileExtension,
                                            ));
                                          }
                                          shareFile(
                                              multiShare: true,
                                              songList: songdata);
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
                                      ],
                                    ),
                                    onTap: () {
                                      if (!isCheckable) {
                                        setState(
                                          () {
                                            setCurrentlyPlayingSong(song
                                                .data![index].displayNameWOExt);
                                            context
                                                .read<SongModelProvider>()
                                                .setId(song.data![index].id);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioMainPlayer(
                                                  songData: song.data!,
                                                  index: index,
                                                  audioPlayer:
                                                      widget.audioPlayer,
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
                                    id: song.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note),
                                  ),
                                  title: Text(
                                    song.data![index].displayNameWOExt,
                                    maxLines: 1,
                                    style: isPlaying && isCurrentlyPlaying
                                        ? const TextStyle(color: Colors.blue)
                                        : null,
                                  ),
                                  subtitle: Text(
                                    song.data![index].artist.toString() ==
                                            "<unknown>"
                                        ? "unknown"
                                        : song.data![index].artist.toString() ==
                                                'null'
                                            ? 'unknown'
                                            : song.data![index].artist
                                                .toString(),
                                  ),
                                  //Select option with checkable list tile
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
                                          uri: song.data![index].uri!,
                                          fileName: song
                                              .data![index].displayNameWOExt,
                                          fileExtension:
                                              song.data![index].fileExtension,
                                          multiShare: false,
                                        );
                                      } else if (value == 'information') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SongDetailsDialog(
                                              songData: song.data![index],
                                            );
                                          },
                                        );
                                      } else if (value == 'delete') {
                                        deleteHandler.getDeletingFilesPath(songData: [songMainData(song.data![index].uri!, '', '')],multiDelete: false);
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
                                        setCurrentlyPlayingSong(
                                            song.data![index].displayNameWOExt);
                                        context
                                            .read<SongModelProvider>()
                                            .setId(song.data![index].id);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AudioMainPlayer(
                                              songData: song.data!,
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
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
