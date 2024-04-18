// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jadwali_test_1/modules/Ucode.dart';
import 'package:jadwali_test_1/modules/child.dart';

class childAuth {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // String Ucode;

  // childAuth{
  //   this.Ucode;
  // }

  Future<Child?> getChildWithSpecificUcode(
      String enteredCode) async {
    // Reference to the Firestore collection
    CollectionReference<Map<String, dynamic>> ucodeRef =
        FirebaseFirestore.instance.collection("specialCodes");

    // Create a query to retrieve documents where a specific field equals a certain value
    Query<Map<String, dynamic>> query =
        ucodeRef.where(childUCode, isEqualTo: enteredCode).limit(1);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
     String childReferenceId = querySnapshot.docs.first.get(profileId);//get child id
    
    // Reference to the Firestore collection "child"
    CollectionReference<Map<String, dynamic>> childRef =
        FirebaseFirestore.instance.collection(collectionChild);

    // Retrieve the child object using the reference ID
    DocumentSnapshot<Map<String, dynamic>> childSnapshot =
        await childRef.doc(childReferenceId).get();

    // Map the child data to a ChildObject instance
     Child childUser = Child.fromMap(childSnapshot.data()?? {});

    return childUser;
  } else {
    // If no document matches the unique code, return null
    return null;
  }
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getucode() {
  //   // Reference to the Firestore collection
  //    CollectionReference<Map<String, dynamic>> ucodeRef =
  //       FirebaseFirestore.instance.collection("specialCodes");

  //   // Create a query to retrieve documents where a specific field equals a certain value
  //   Query<Map<String, dynamic>> query =
  //       ucodeRef.where(childUCode, isEqualTo: 'enteredCode').limit(1);

  //   // Return a stream of query snapshots
  //   return query.snapshots();
  // }
}
