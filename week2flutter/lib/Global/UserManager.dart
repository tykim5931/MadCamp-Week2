import 'package:flutter/material.dart';
import '../data/User.dart';

class UserManager with ChangeNotifier{
  User _rootUser = User(id: "짱구", email: "email@email.com", pw:"12345");
  User _selectedUser = User(id: "짱구", email: "email@email.com", pw:"12345");
  User get root => _rootUser;
  User get selected => _selectedUser;

  set selected(User user){
    _selectedUser = user;
    notifyListeners();
    print(user.id);
  }

  set root(User user){
    _rootUser = user;
    notifyListeners();
    print(user.id);
  }
}