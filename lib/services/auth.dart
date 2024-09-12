import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/authenticate/sign_in.dart';
import 'package:flutter_firebase/model/user.dart';
import 'package:flutter_firebase/services/database.dart';

class AuthServices{

 AuthServices() {
    Firebase.initializeApp();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Userinfo _userFromFirebaseUser(User userid){
    return userid != null ? Userinfo(uid: userid.uid) : Userinfo(uid: '');
  }

  //auth change user stream

  Stream<Userinfo?> get user {
  return _auth.authStateChanges().map((User? user) {
    if (user == null) {
      return null;
    }

    return Userinfo(uid: user.uid);
  });
}


  //sign in anon
  Future<Userinfo?> signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String name,String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(name,email,password);

      return _userFromFirebaseUser(user!);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //reset password
  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}