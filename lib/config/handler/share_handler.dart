import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hplayer/model/song_main_data.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

void shareFile({
  String uri = '',
  String fileName = '',
  String fileExtension = '',
  bool multiShare = false,
  List<songMainData> songList = const [],
}) async {
  try {
    if (!multiShare) {
      String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
        uri: uri,
        outputFileName: fileName,
        fileExtension: fileExtension,
      );

      if (await File(filePath!).exists()) {
        await Share.shareXFiles(
          subject: '',
          text: '',
          [XFile(filePath!)],
        );
      } else {
        Fluttertoast.showToast(
          msg: 'File does not exist: $filePath!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        debugPrint('File does not exist: $filePath');
      }
    } else {
      List<XFile>? filesPaths = [];
      for (final fileUri in songList) {
        final String? fileAbsolutePath =
            await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: fileUri.uri!,
          fileExtension: fileUri.fileExtension,
          outputFileName: fileUri.fileName,
        );
        filesPaths.add(XFile(fileAbsolutePath ?? ''));
      }
      await Share.shareXFiles(filesPaths, subject: '', text: '');
    }
  } on Exception {
    Fluttertoast.showToast(
      msg: 'File does not exist!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    debugPrint('File does not exist');
  }
}
