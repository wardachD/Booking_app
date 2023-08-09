import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  User? user;

  UserDataProvider() {
    user = FirebaseAuth.instance.currentUser;
  }

  void refreshUser() {
    user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
