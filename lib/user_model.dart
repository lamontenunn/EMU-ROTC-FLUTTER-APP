import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserType { MS1, MS2, MS3, MS4, Cadre, Guest }


Future<UserType> getUserType() async {
  // Get the current user's UID.
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  // Fetch the user's UserType from Firestore using the UID.
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  
  if (!userDoc.exists) {
    throw Exception('User not found in Firestore');
  }

  // Deserialize the UserType from the fetched data.
  final userTypeStr = userDoc['userType'] as String;
  final userType = UserType.values.firstWhere((e) => e.toString() == 'UserType.$userTypeStr');

  return userType;
}

Future<List<QueryDocumentSnapshot>> getChannelsForUser() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final userType = await getUserType();

  final channels = await FirebaseFirestore.instance
      .collection('channels')
      .where('userTypes', arrayContains: userType.toString().split('.').last)
      .get();

  return channels.docs;
}


enum ArmyRank {
 Private,
  Private_First_Class,
  Specialist,
  Corporal,
  Sergeant,
  Staff_Sergeant,
  Sergeant_First_Class,
  Master_Sergeant,
  First_Sergeant,
  Sergeant_Major,
  Command_Sergeant_Major,
  SecondLieutenant,
  FirstLieutenant,
  Captain,
  Major,
  LieutenantColonel,
  Colonel,
}

enum LeaderShipPos {
B2PSG,
B1PSG,
BXO,
B1SG,
A2PSG,
A1PSG,
AXO,
A1SG,
B2PL,
B1PL,
BCoCDR,
A2PL,
A1PL,
ACoCDR,
AS6,
S6,
AS4,
S4,
AS2,
S2,
AS1,
S1,
AS3,
S3,
BNXO,
CSM,
BC
}

class UserModel {
  final String uid;
  final String username;
  final String email;
  final UserType userType;
  final ArmyRank armyRank;
  final String? profilePictureUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userType,
    required this.armyRank,
    this.profilePictureUrl,
  });



String get armyRankString => armyRank.toString().split('.').last;
String get userTypeString => userType.toString().split('.').last;
}
