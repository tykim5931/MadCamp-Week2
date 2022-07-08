import 'package:flutter/material.dart';

class User{
  late String id;
  late String email;
  late String pw;
  int point = 0;

  User({required this.id, required this.email, required this.pw});
}