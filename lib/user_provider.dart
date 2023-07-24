import 'package:flutter/foundation.dart';
import 'user_model.dart';

class UserProvider with ChangeNotifier {
  late UserModel _currentUser;

  UserModel get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}

class User {
  final String uid;
  final String email;
  final ArmyRank armyRank;
  final UserType userType;

  User({required this.uid, required this.email, required this.armyRank, required this.userType});

  String get armyRankString => armyRank.toString().split('.').last;
  String get userTypeString => userType.toString().split('.').last;
}

