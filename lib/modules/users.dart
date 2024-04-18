// ignore_for_file: camel_case_types

const String userEmail = "email";
const String userName = "name";
const String userAccountType = "accountType";
const String userUcode = "ucode";

class user{
  final String? email;
  final String? name;
  final String? accountType;
  final String? ucode;

  user({required this.email, required this.name, required this.accountType,  this.ucode});

Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userEmail: email,
      userName: name,
      userAccountType: accountType,
      userUcode: ucode,
    };
  }

    factory user.fromMap(Map<String, dynamic> map) => user(
      email: map[userEmail],
      name: map[userName],
      accountType: map[userAccountType],
      ucode: map[userUcode],
      );
}


