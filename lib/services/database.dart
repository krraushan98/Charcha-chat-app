import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/services/notification_api.dart';

// Update database.dart
class Message {
  final String senderUid;
  final String senderName;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.senderUid,
    required this.senderName,
    required this.content,
    required this.timestamp,
  });
}

class DatabaseService {
  
final String uid;
  DatabaseService({required this.uid});
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');
      final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

      Future updateUserData(String name, String email, String password) async {
    DocumentReference docRef = userCollection.doc(uid);
    return await docRef.set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future sendMessage(String content, String uid) async {
     DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(uid);
     DocumentSnapshot snapshot = await docRef.get();
      String name = snapshot.get('name');
      NotificationApi.sendNotification(name, content);
  return await messageCollection.add({
    'senderUid': uid,
    'senderName': name, 
    'content': content,
    'timestamp': FieldValue.serverTimestamp()  
  });
}

  Stream<List<Message>> get messages {
    return messageCollection.orderBy('timestamp').snapshots()
        .map(_messageListFromSnapshot);
  }

  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['timestamp'] is Timestamp
        ? (data['timestamp'] as Timestamp)
        : Timestamp.fromDate(DateTime.now());
      return Message(
        senderUid: data['senderUid'] ?? '',
        senderName: data['senderName'] ?? '',
        content: data['content'] ?? '',
        timestamp: timestamp,
      );
    }).toList();
  }
}

