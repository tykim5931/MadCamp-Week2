import 'dart:typed_data';
import 'package:flutter/material.dart';

class User{
  String id;
  String nickname;
  // Null blobimg = null; // display
  int point = 0;
  int level = 1;
  int dia = 0;
  int currentdia = 0;


  User({required this.id,
    required this.nickname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
    );
    user.level = json['level'] as int;
    user.dia = json['dia'] as int;
    user.currentdia = json['currentdia'] as int;
    user.point = json['point'] as int;
    return user;
  }
  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'nickname':nickname,
        'level': level,
        'point':point,
        'dia':dia,
        'currentdia':currentdia,
      };

 void addPoint(int add){
    this.point += add;
  }
}