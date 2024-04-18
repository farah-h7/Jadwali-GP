

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jadwali_test_1/db/db_helper.dart';

class AuthService {
  //getters
  static final FirebaseAuth _auth =
      FirebaseAuth.instance; // get a firebase instance
  static User? get currentUser => _auth.currentUser; // ?: nunnable // gets current loged in user

  static Future<bool> loginP(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    //credential.user.metadata.  --> you can get info about the user form this
    return DbHelper.isP(credential.user!.uid);
  }

  static Future<bool> loginC(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    //credential.user.metadata.  --> you can get info about the user form this
    return DbHelper.isC(credential.user!.uid);
  }

  static Future<String> getcurrentusercode() async {
     DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid);
    DocumentSnapshot doc = await docRef.get();
     var ucode = doc.get('ucode');
    
    return ucode;
  }
// this is another method
  static Future<void> logout(){
     
    return _auth.signOut();
  }

}
