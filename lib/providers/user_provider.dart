import 'package:flutter/material.dart';
import 'package:instagram/models/usermodel.dart';
import 'package:instagram/services/authmethods.dart';

class UserProvider with ChangeNotifier {
  final Authentication _authMethods = Authentication();
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      UserModel userModel = await _authMethods.getUserDetails();
      _user = userModel;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
