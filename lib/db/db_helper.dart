// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';
import 'package:jadwali_test_1/modules/Ucode.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/modules/users.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionAdmin =
      'Parent'; // has to be same name as in firestore

  static const String collectionUsers = "users";

  static Future<bool> isP(String uid) async {
    final snapshot = await _db.collection(collectionUsers).doc(uid).get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!['accountType'] == 'p') {
      return true;
    }
    return false;
  }

  static Future<bool> isC(String uid) async {
    final snapshot = await _db.collection(collectionUsers).doc(uid).get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!['accountType'] == 'c') {
      return true;
    }
    return false;
  }

  static Future<bool> isParent(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    //.doc method returns a document reference from the collection? or creates a new document
    // pass uid in doc to access a document
    // to get data from document you can call .get method or .snapshot
    // get method only gets a document once??
    return snapshot.exists;
  }

  

// sends a child to firebase
  static Future<void> addChildDb(Child newchild) {
//create a new document in a collection in firebase
    final doc = _db
        .collection(collectionChild)
        .doc(); // return a document reference, this also automaticaly generates an ID
    // set child id to the document id
    newchild.id = doc.id;
    newchild.parentID = AuthService.currentUser!.uid;

    final doc2 = _db.collection("specialCodes").doc(newchild.ucode);

    Ucode newCode = Ucode(
        ucode: newchild.ucode,
        childProfileID: newchild.id,
        parentID: newchild.parentID);
    doc2.set(newCode.toMap());

    return doc.set(newchild.toMap());
  }

  static Future<bool> checkValidUcode(String ucode, String parentEmail) async {
    //get ucode
    final snapshot = await _db.collection("specialCodes").doc(ucode).get();
    if (!snapshot.exists) {
      //id code does not exist
      return false;
    }

    String? taken = snapshot.data()?["child ID"];
    if (taken != null) {
      return false;
    }

    String PID = snapshot
        .data()!['parent ID']; //get prent id from specialcode collection
    final snapshot2 = await _db
        .collection("users")
        .doc(PID)
        .get(); // get email for parent with pid

    if (snapshot2.data()!['email'] == parentEmail) {
      // if email matched
      return true;
    }

    return false;
  }

  static Future<void> updateUcode(String ucode, String childID) async {
    _db.collection("specialCodes").doc(ucode).update({"child ID": childID});
  }

//add child user to user collection
  static Future<void> addChilduserDb(user newchilduser, String userid) {
//create a new document in a collection in firebase

    final doc2 = _db.collection("users").doc(userid);

    return doc2.set(newchilduser.toMap());
  }

//retrive all children
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChildren() => _db
      .collection(collectionChild)
      .snapshots(); //return a stream of query sapshots?

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getAllChildrenWithSpecificField() {
    // Reference to the Firestore collection
    CollectionReference<Map<String, dynamic>> childrenRef =
        FirebaseFirestore.instance.collection(collectionChild);

    // Create a query to retrieve documents where a specific field equals a certain value
    Query<Map<String, dynamic>> query = childrenRef.where(childParentId,
        isEqualTo: AuthService.currentUser!.uid);

    // Return a stream of query snapshots
    return query.snapshots();
  }
}
