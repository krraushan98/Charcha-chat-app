import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/msg_List.dart';
import 'package:flutter_firebase/home/popup_menu.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});
  AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    AuthServices _auth = AuthServices();
    TextEditingController messageController = TextEditingController();

    return StreamProvider<List<Message>>.value(
      initialData: List.empty(),
      value: DatabaseService(uid: '').messages,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          title: Image.asset(
            'assests/charcha.png',
            height: 50,
          ),
          centerTitle: true,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(255, 211, 197, 191),
              ),
              label: const Text(''),
              onPressed: ()  {
                //await _auth.signOut();
                PopupMenuWidget.showPopupMenu(context);
              },
            ),
          ],
        ),
      body: Container(
        decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assests/background.jpg'), // Replace with the actual image path
        fit: BoxFit.cover,
      ),
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
        child: msgList(),
          ),
          Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    hintText: 'Enter your message',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: Color.fromARGB(255, 201, 124, 31),
                      size: 40,
                  ),
                  onPressed: () async {
                    String content = messageController.text;
                    if(content.isEmpty) return;
                    // Get the sender's name from the authentication
                    messageController.clear();
                    Userinfo? user = context.read<Userinfo?>();
                    String userId = user?.uid ?? 'Anonymous';
              
                    // Send the message with the sender's name
                    await DatabaseService(uid: '').sendMessage(
                      content,
                      userId,
                    );
                    
                  },
                ),
              ),
            ],
          ),
        ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
