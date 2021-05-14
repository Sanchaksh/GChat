import 'package:firebase_auth/firebase_auth.dart';
import 'package:g_chat/modal/user.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  appUse _userFromFirebase(User user) {
    return user!=null ?   appUse(uId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user;

      return _userFromFirebase(firebaseUser);

    }catch(e){
      print(e.toString());
    }
  }
  Future signUpwithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      
      return _userFromFirebase(firebaseUser);
    }catch(e) {
      print(e.toString());
    }
  }
  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){

    }
  }
}