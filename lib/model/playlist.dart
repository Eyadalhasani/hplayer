import 'package:flutter/material.dart';
import 'package:flutter_draggable_list/flutter_draggable_list.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
class Playlist extends StatefulWidget {
  final String playedScreen;
  final AudioPlayer audioPlayer;
  final List<SongModel> songData;
  final int index;
  const Playlist({super.key, required this.playedScreen, required this.audioPlayer, required this.songData, required this.index});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {


  @override
  Widget build(BuildContext context) {
    return
       Container(
        decoration: BoxDecoration(
          color: Colors.grey ,
          borderRadius: BorderRadius.circular(5)
        ),
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PlayList'),
                    IconButton(
                      icon: const Icon(Icons.repeat),
                      onPressed: () {
                        
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: DragAndDropList<SongModel>(
                widget.songData,
                itemBuilder: (context, song) {
                  return  SizedBox(
                  child:  Card(
                  child:  ListTile(
                  title:  Text(song.displayNameWOExt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    
                  ),
                    onTap: (){

                    },
                  ),
                  ),
                  );
                  },
                  onDragFinish: (before, after) {
                  widget.songData.removeAt(before);
                  widget.songData.insert(after, widget.songData[before]);
                  },
                  canBeDraggedTo: (one, two) => true,
                  dragElevation: 8.0,
                ),
    ),
          ],
        ),
       );
  }
}
