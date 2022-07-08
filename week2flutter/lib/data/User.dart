import 'package:flutter/material.dart';

class User{
  late String id;
  late String email;
  late String pw;
  int point = 0;
  int gotchya = 1;

  User({required this.id, required this.email, required this.pw});

  void addPoint(int add){
    this.point += add;
  }
  void addTry(){
    this.gotchya += 1;
  }
}