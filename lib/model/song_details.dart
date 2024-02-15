import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDetailsDialog extends StatefulWidget {
  final SongModel songData;

  const SongDetailsDialog({
    super.key,
    required this.songData,
  });

  @override
  State<SongDetailsDialog> createState() => _SongDetailsDialogState();
}

class _SongDetailsDialogState extends State<SongDetailsDialog> {
  String filePath = '';

  String formatDate(int? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }

    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String formatDuration(int? duration) {
    if (duration == null) {
      return 'N/A';
    }

    final int seconds = duration ~/ 1000;
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    final String formattedHours = hours.toString().padLeft(2, '0');
    final String formattedMinutes = minutes.toString().padLeft(2, '0');
    final String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    if (formattedHours == '00') {
      return '$formattedMinutes:$formattedSeconds';
    } else {
      return '$formattedHours:$formattedMinutes:$formattedSeconds';
    }
  }

  @override
  void initState() {
    filepath();
    super.initState();
  }

  Future<String> filepath() async {
    final path = (await LecleFlutterAbsolutePath.getAbsolutePath(
      uri: widget.songData.uri!,
      outputFileName: widget.songData.displayNameWOExt,
      fileExtension: widget.songData.fileExtension,
    ))!;
    setState(() {
      filePath = path ;
    });
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSongNameLong = widget.songData.displayNameWOExt.length > 20;
    final bool isSongAlbumLong = (widget.songData.album?.length ?? 0) > 20;
    final bool isSongArtistLong = (widget.songData.artist?.length ?? 0) > 20;
    final bool isSongPathLong = (widget.songData.uri?.length ?? 0) > 20;
    final bool isSongGenerLong = (widget.songData.genre?.length ?? 0) > 20;
    return AlertDialog(
      title: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width / 2.8,
        height: MediaQuery.of(context).size.height * 0.05,
        child: isSongNameLong
            ? Marquee(
                text: widget.songData.displayNameWOExt,
                style: Theme.of(context).textTheme.titleMedium,
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                showFadingOnlyWhenScrolling: true,
                fadingEdgeStartFraction: 0.1,
                fadingEdgeEndFraction: 0.1,
              )
            : Text(
                widget.songData.displayNameWOExt,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
      ),
      content: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Album: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: isSongAlbumLong
                      ? Marquee(
                          text: widget.songData.album ?? 'null',
                          style: Theme.of(context).textTheme.titleMedium,
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          showFadingOnlyWhenScrolling: true,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                        )
                      : Text(
                          widget.songData.album ?? 'null',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Artist: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: isSongArtistLong
                      ? Marquee(
                          text: widget.songData.artist == '<unknown>'
                              ? 'unknown'
                              : widget.songData.artist ?? 'unknown',
                          style: Theme.of(context).textTheme.titleMedium,
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          showFadingOnlyWhenScrolling: true,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                        )
                      : Text(
                          widget.songData.artist == '<unknown>'
                              ? 'unknown'
                              : widget.songData.artist ?? 'unknown',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Path: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: filePath.isNotEmpty
                      ? isSongPathLong
                          ? Marquee(
                              text: filePath,
                              style: Theme.of(context).textTheme.titleMedium,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 20.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              showFadingOnlyWhenScrolling: true,
                              fadingEdgeStartFraction: 0.1,
                              fadingEdgeEndFraction: 0.1,
                            )
                          : Text(
                              filePath,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                      : const SizedBox(height: 0,), // or any other fallback widget if filePath is null or empty
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Size: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${double.parse((widget.songData.size / 1024 / 1024).toStringAsExponential(2)).toString()} MB',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Date Added: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatDate(widget.songData.dateAdded),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Date Modified: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatDate(widget.songData.dateModified),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Format: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.songData.fileExtension,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Duration: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatDuration(widget.songData.duration),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Genre: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 2.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: isSongGenerLong
                      ? Marquee(
                          text: widget.songData.genre ?? 'unknown',
                          style: Theme.of(context).textTheme.titleMedium,
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          showFadingOnlyWhenScrolling: true,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                        )
                      : Text(
                          widget.songData.genre ?? 'unknown',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                ),
              ],
            ),
            // Add the remaining rows for other song details
          ],
        ),
      ),
    );
  }
}
