import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/update.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';

class msgList extends StatefulWidget {
  const msgList({Key? key}) : super(key: key);

  @override
  State<msgList> createState() => _msgListState();
}

class _msgListState extends State<msgList> {
  late ScrollController _scrollController;
  

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<Message>>(context);
    final user = Provider.of<Userinfo?>(context)!;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          int reversedIndex = messages.length - 1 - index;

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Color.fromARGB(255, 235, 236, 238)?.withOpacity(1),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          messages[reversedIndex].senderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          messages[reversedIndex].content,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if(user.uid == messages[reversedIndex].senderUid)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                             showDialog(
                                context: context,
                                builder: (context) {
                                  return UpdateDialog(
                                    messageId: messages[reversedIndex].messageId,
                                    content: messages[reversedIndex].content,
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () {
                              DatabaseService(uid: '').deleteMessage(
                                  messages[reversedIndex].messageId);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Scroll to the end when the widget is built
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    });
  }
}
