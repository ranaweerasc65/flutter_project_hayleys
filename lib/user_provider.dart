import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _phoneNo = '';

  String get username => _username;
  String get phoneNo => _phoneNo;

  void setUser(String username, String phoneNo) {
    _username = username;
    _phoneNo = phoneNo;
    notifyListeners();
  }
}
