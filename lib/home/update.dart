import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/database.dart';

class UpdateDialog extends StatefulWidget {
  final String messageId; 
  final String content;   

  const UpdateDialog({
    Key? key,
    required this.messageId,
    required this.content,
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: widget.content); 
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Message'),
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          const Text('Enter the new message content'),
          const SizedBox(height: 10),
          TextField(
            maxLines: null,
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'New message',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Update the message in Firestore
            DatabaseService(uid: '').updateMessage(
              widget.messageId, 
              messageController.text, 
            );
            Navigator.pop(context, 'Update');
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    messageController.dispose(); 
    super.dispose();
  }
}