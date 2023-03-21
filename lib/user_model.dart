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
  Private2,
  PrivateFirstClass,
  Specialist,
  Corporal,
  Sergeant,
  StaffSergeant,
  SergeantFirstClass,
  MasterSergeant,
  FirstSergeant,
  CommandSergeantMajor,
  SecondLieutenant,
  FirstLieutenant,
  Captain,
  Major,
  LieutenantColonel,
  Colonel,
}

enum LeaderShipPos {
BC,
CSM,
BNXO,
S3,
AS3,
S1,
AS1,
S2,
AS2,
S4,
AS4,
S6,
AS6,
ACoCDR,
A1PL,
A2PL,
BCoCDR,
B1PL, 
B2PL, 
A1SG,
AXO,
A1PSG,
A2PSG,
B1SG,
BXO,
B1PSG,
B2PSG,
}

class UserModel {
  final String uid;
  final String username;
  final String email;
  final UserType userType;
  final ArmyRank armyRank;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userType,
    required this.armyRank,
  });


}