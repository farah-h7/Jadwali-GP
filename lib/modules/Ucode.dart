// ignore_for_file: file_names

const String childUCode = 'special code';
const String child = "child ID";
const String parent = 'parent ID';
const String profileId = 'child profile id';

class Ucode {
  final String? ucode;
  String? childID = "";// will be filled later when a child user is created
  final String? parentID;
  final String? childProfileID; 

  Ucode({
    required this.ucode,
    this.childID,
    required this.parentID,
    required this.childProfileID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //db,object
      childUCode: ucode,
      child: childID,
      parent: parentID,
      profileId : childProfileID,
    };
  }

// to retrieve map from database
  factory Ucode.fromMap(Map<String, dynamic> map) => Ucode(
        //object, db 
        ucode: map[childUCode],
        childID: map[child],
        parentID: map[parent],
        childProfileID: map[profileId],
      );
}
