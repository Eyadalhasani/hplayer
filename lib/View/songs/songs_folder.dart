import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hplayer/model/songs_viwer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as path;

class SongsFolder extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final OnAudioQuery audioQuery;

  const SongsFolder(
      {super.key, required this.audioPlayer, required this.audioQuery});

  @override
  _SongsFolderState createState() => _SongsFolderState();
}

class _SongsFolderState extends State<SongsFolder> {
  late Future<List<String>> _foldersFuture;

  @override
  void initState() {
    super.initState();
    _foldersFuture = fetchFolders();
  }

  Future<List<String>> fetchFolders() async {
    //Android Only
    if(Platform.isAndroid){
    final folders = await widget.audioQuery.queryAllPath();
    return folders;
    } else
      {
        return
            [];
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<String>>(
        future: _foldersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final folders = snapshot.data ?? [];
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    final folderName = path.basename(folder);
                    final isExternalFolder = !folder.contains('emulated');

                    return Container(
                      margin: const EdgeInsets.all(6),
                      child: ListTile(
                        leading: isExternalFolder
                            ? const Icon(Icons.sd_card, size: 30)
                            : const Icon(Icons.folder, size: 30),
                        title: Text(
                          folderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          folder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongViewerScreen(
                                folderPath: folder,
                                filterType: FilterType.folder,
                                audioPlayer: widget.audioPlayer,
                                audioQuery: widget.audioQuery,
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
