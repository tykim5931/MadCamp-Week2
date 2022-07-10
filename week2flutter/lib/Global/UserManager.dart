import 'package:flutter/material.dart';
import '../data/User.dart';

class UserManager with ChangeNotifier{
  User _rootUser = User(id: "test1", nickname: "짱구");
  User _selectedUser = User(id: "test1", nickname: "짱구");
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