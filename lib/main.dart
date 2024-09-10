
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/notification_api.dart';
import 'package:flutter_firebase/wrapper.dart';
import 'package:provider/provider.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
       NotificationApi notificationApi = NotificationApi();
        notificationApi.initNotificatoins();
    runApp(MyApp());
  }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return StreamProvider<Userinfo?>.value(
  value: AuthServices().user,
  initialData: Userinfo(uid: ''),
  child: const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Wrapper(),
  ),
);
  }
}
