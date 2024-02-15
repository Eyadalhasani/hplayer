import 'package:flutter/material.dart';
import 'package:hplayer/config/handler/delete_handler.dart';

class DeleteDialog extends StatefulWidget {
  final double fielsCount;
  const DeleteDialog({super.key, required this.fielsCount});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title:const Text('Deleting Files'),
      content: Column(
        children: [
          Expanded(
              child: LinearProgressIndicator(
                 value: progress / widget.fielsCount ,
                 minHeight: MediaQuery.of(context).size.height,
                 borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),),
        ],
      ),
    );
  }
}
