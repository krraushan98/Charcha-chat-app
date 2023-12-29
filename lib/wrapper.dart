import 'package:flutter/material.dart';
import 'package:flutter_firebase/authenticate/authenticate.dart';
import 'package:flutter_firebase/home/home.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userinfo?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
