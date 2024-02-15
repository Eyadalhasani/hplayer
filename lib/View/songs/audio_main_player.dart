// ignore_for_file: constant_identifier_names
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hplayer/View/songs/all_song.dart';
import 'package:hplayer/config/provider/song_model_provider.dart';
import 'package:hplayer/model/equalizer.dart';
import 'package:hplayer/model/playlist.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

bool isPlaying = false;

enum RepeatMode { None, Repeat, Shuffle, Order }

class AudioMainPlayer extends StatefulWidget {
  final List<SongModel> songData;
  final AudioPlayer audioPlayer;
  final int index;

  const AudioMainPlayer(
      {super.key,
      required this.songData,
      required this.audioPlayer,
      required this.index});

  @override
  State<AudioMainPlayer> createState() => _AudioMainPlayerState();
}

class _AudioMainPlayerState extends State<AudioMainPlayer> {
  bool isPlaylistShowed = false;
  Duration duration = const Duration(seconds: 0);
  Duration position = const Duration(seconds: 0);
  var repeatMode = RepeatMode.None;
  List<AudioSource> songsList = [];
  late int currentIndex;

  playSong(String uri) {
    try {
      for (var elements in widget.songData) {
        songsList.add(AudioSource.uri(Uri.parse(elements.uri!),
            tag: MediaItem(
                id: elements.id.toString(),
                title: elements.displayNameWOExt,
                album: elements.album ?? "No Album",
                artUri: Uri.parse(elements.id.toString()))));
      }
      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songsList,
          useLazyPreparation: false,
        ),
        initialIndex: currentIndex,
      );
      widget.audioPlayer.durationStream.listen((durations) {
        if (mounted) {
          setState(() {
            duration = durations!;
          });
        }
      });

      widget.audioPlayer.positionStream.listen((positions) {
        if (mounted) {
          setState(() {
            position = positions;
          });
        }
      });
      listenToMode();

      if (isPlaying &&
          currentlyPlayingSong ==
              widget.songData[currentIndex].displayNameWOExt) {
        debugPrint("here s Play song");
      } else {
        widget.audioPlayer.play();
      }

      listenToEvent();
      listenToSongIndex();
    } on Exception {
      debugPrint("Cannot Play song");
    }
  }

  void listenToMode() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          if (state.processingState == ProcessingState.completed) {
            if (repeatMode == RepeatMode.Repeat) {
              widget.audioPlayer.setLoopMode(LoopMode.one);
            } else if (repeatMode == RepeatMode.Shuffle) {
              widget.audioPlayer.setShuffleModeEnabled(true);
            } else if (repeatMode == RepeatMode.Order) {
              widget.audioPlayer.setShuffleModeEnabled(false);
              widget.audioPlayer.setLoopMode(LoopMode.all);
            } else if (repeatMode == RepeatMode.None) {
              widget.audioPlayer.setLoopMode(LoopMode.off);
            }
          }
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen((songIndex) {
      if (mounted) {
        setState(() {
          if (songIndex != null) {
            currentIndex = songIndex;
          }
          context
              .read<SongModelProvider>()
              .setId(widget.songData[currentIndex].id);
        });
      }
    });
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        if (state.playing) {
          isPlaying = true;
        } else {
          isPlaying = false;
        }
      });
    });
  }

  changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    playSong(widget.songData[currentIndex].uri!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back_ios),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EqualizerScreen(
                            audioPlayer: widget.audioPlayer,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.equalizer_rounded,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Center(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        //Song Icon
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: MediaQuery.of(context).size.height * 0.23,
                          decoration: const BoxDecoration(
                              color: Colors.white38, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const ArtWorkWidget(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        //Song Name
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 200,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Marquee(
                            text:
                                widget.songData[currentIndex].displayNameWOExt,
                            style: Theme.of(context).textTheme.titleMedium,
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 20.0,
                            velocity: 50.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            showFadingOnlyWhenScrolling: true,
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        //Artist
                        Text(
                          widget.songData[currentIndex].artist == "<unknown>"
                              ? "unknown"
                              : widget.songData[currentIndex].artist.toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        //Repeat , favorite , timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: repeatMode == RepeatMode.None
                                  ? const Icon(Icons.repeat)
                                  : repeatMode == RepeatMode.Repeat
                                      ? const Icon(Icons.repeat_one,
                                          color: Colors.blue)
                                      : repeatMode == RepeatMode.Shuffle
                                          ? const Icon(Icons.shuffle,
                                              color: Colors.blue)
                                          : repeatMode == RepeatMode.Order
                                              ? const Icon(Icons.repeat,
                                                  color: Colors.blue)
                                              : const Icon(Icons.repeat),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    if (repeatMode == RepeatMode.Order) {
                                      listenToMode();
                                      if (position.inSeconds.toDouble() ==
                                          duration.inSeconds.toDouble()) {
                                        widget.audioPlayer.stop();
                                      }
                                    } else if (repeatMode == RepeatMode.None) {
                                      repeatMode = RepeatMode.Repeat;
                                      listenToMode();
                                    } else if (repeatMode ==
                                        RepeatMode.Repeat) {
                                      repeatMode = RepeatMode.Shuffle;
                                      listenToMode();
                                    } else if (repeatMode ==
                                        RepeatMode.Shuffle) {
                                      repeatMode = RepeatMode.Order;
                                      listenToMode();
                                    }
                                  });
                                }
                              },
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.timer))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        //Song seek
                        Row(
                          children: [
                            Text(
                              position.toString().split('.')[0],
                              style: const TextStyle(color: Colors.black),
                            ),
                            Expanded(
                              child: Slider(
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(),
                                activeColor: Colors.black38,
                                secondaryActiveColor: Colors.black54,
                                inactiveColor: Colors.black12,
                                thumbColor: Colors.black45,
                                label: position.inSeconds.toDouble().toString(),
                                onChanged: (newValue) {
                                  if (mounted) {
                                    setState(
                                      () {
                                        changeToSeconds(newValue.toInt());
                                        newValue = newValue;
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            Text(
                              duration.toString().split('.')[0],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        //Play , next ,previous
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (widget.audioPlayer.hasPrevious) {
                                    widget.audioPlayer.seekToPrevious();
                                    setState(
                                      () {
                                        currentlyPlayingSong = widget
                                            .songData[currentIndex]
                                            .displayNameWOExt;
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_previous_outlined,
                                  size: 45,
                                ),
                              ),
                              //play song
                              CircleAvatar(
                                radius: 30,
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          if (isPlaying) {
                                            widget.audioPlayer.pause();
                                          } else {
                                            widget.audioPlayer.play();
                                          }
                                        });
                                      }
                                    },
                                    icon: isPlaying
                                        ? const Icon(
                                            Icons.pause,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                          ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (widget.audioPlayer.hasNext) {
                                    widget.audioPlayer.seekToNext();
                                    setState(() {
                                      currentlyPlayingSong = widget
                                          .songData[currentIndex]
                                          .displayNameWOExt;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_next_outlined,
                                  size: 45,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        //playlist ,speed , fast
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (position <= Duration.zero) {
                                  position = Duration.zero;
                                } else {
                                  position -= const Duration(seconds: 5);
                                  if (position <= Duration.zero) {
                                    position = Duration.zero;
                                  }
                                }
                                widget.audioPlayer.seek(position);
                                widget.audioPlayer.seek(position);
                              },
                              icon: const Icon(Icons.fast_rewind_outlined),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Adjust Speed',
                                            style: TextStyle(
                                                color: Colors.black54)),
                                        content: StreamBuilder<double>(
                                          stream:
                                              widget.audioPlayer.speedStream,
                                          builder: (context, snapshot) {
                                            final double sliderValue =
                                                snapshot.data ??
                                                    widget.audioPlayer.speed;

                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Slider(
                                                  value: sliderValue,
                                                  divisions: 10,
                                                  min: 0.5,
                                                  max: 1.5,
                                                  onChanged: (newValue) {
                                                    widget.audioPlayer
                                                        .setSpeed(newValue);
                                                  },
                                                ),
                                                Center(
                                                  child: Text('$sliderValue',
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54)),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.speed_outlined)),
                            IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(
                                      () {
                                        isPlaylistShowed = !isPlaylistShowed;
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(Icons.playlist_play)),
                            IconButton(
                                onPressed: () {
                                  widget.audioPlayer.seek(
                                      position += const Duration(seconds: 5));
                                },
                                icon: const Icon(Icons.fast_forward_outlined)),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isPlaylistShowed,
                      child: Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Playlist(
                            audioPlayer: widget.audioPlayer,
                            playedScreen: 'All',
                            songData: widget.songData,
                            index: widget.index),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      artworkWidth: double.infinity,
      artworkHeight: double.infinity,
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Icon(
        Icons.music_note,
        size: 80,
      ),
    );
  }
}
