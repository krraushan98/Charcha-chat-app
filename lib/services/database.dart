import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/services/notification_api.dart';

class Message {
  final String messageId; 
  final String senderUid;
  final String senderName;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.messageId, 
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

  // Update user data
  Future updateUserData(String name, String email, String password) async {
    DocumentReference docRef = userCollection.doc(uid);
    return await docRef.set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Send message
  Future sendMessage(String content, String uid) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snapshot = await docRef.get();
    String name = snapshot.get('name');
    NotificationApi.sendNotification(name, content);

    return await messageCollection.add({
      'senderUid': uid,
      'senderName': name,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Update message
  Future updateMessage(String messageId, String newContent) async {
    try {
      await messageCollection.doc(messageId).update({
        'content': newContent,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Message updated successfully");
    } catch (e) {
      print("Failed to update message: $e");
    }
  }

  // Delete message
  Future deleteMessage(String messageId) async {
    try {
      await messageCollection.doc(messageId).delete();
      print("Message deleted successfully");
    } catch (e) {
      print("Failed to delete message: $e");
    }
  }

  // Get messages stream
  Stream<List<Message>> get messages {
    return messageCollection.orderBy('timestamp').snapshots()
        .map(_messageListFromSnapshot);
  }

  // Convert Firestore snapshot to Message list
  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp)
          : Timestamp.fromDate(DateTime.now());
      return Message(
        messageId: doc.id, 
        senderUid: data['senderUid'] ?? '',
        senderName: data['senderName'] ?? '',
        content: data['content'] ?? '',
        timestamp: timestamp,
      );
    }).toList();
  }
}
