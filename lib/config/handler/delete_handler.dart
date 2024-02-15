import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hplayer/model/song_main_data.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:path_provider/path_provider.dart';

int progress = 0;

class DeleteHandler {
  getDeletingFilesPath(
      {List<songMainData> songData = const [],
      bool multiDelete = false}) async {
    if (!multiDelete) {
      final filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
        uri: songData[0].uri!,
        outputFileName: songData[0].fileName,
        fileExtension: songData[0].fileExtension,
      );
      final file = File(filePath!);
      if (await file.exists()) {
        await file.delete(recursive: true);
      }
    } else {
      for (final mainUri in songData) {
        final fileAbsolutePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: mainUri.uri);
        final File path = File(fileAbsolutePath.toString());
        try {
          await path.delete();
          progress++;
        } catch (e) {
          debugPrint(e.toString());
          continue; // Skip to the next iteration if deletion fails
        }
      }
    }
  }
}
