import 'package:flutter/material.dart';
import 'user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel? newUser) {
    _user = newUser;
    notifyListeners();
  }
}