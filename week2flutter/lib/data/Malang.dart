import 'dart:ffi';
import 'package:flutter/material.dart';

class Malang {
  int id = -1;
  String ownerid;
  int type;
  String createdtime = DateTime.now().toString();
  int price = 0;  // 0
  String nickname;

  Malang({
    required this.ownerid,
    required this.type,
    required this.nickname
  });

  void setPrice(int price){
    this.price = price;
  }
  int getType(){
    return this.type;
  }

  factory Malang.fromJson(Map<String, dynamic> json) {
    Malang malang = Malang(
      ownerid: json['ownerid'] as String,
      nickname: json['nickname'] as String,
      type: json['type'] as int
    );
    malang.createdtime = json['createdtime'] as String;
    malang.price = json['price'] as int;
    malang.id = json['id'] as int;
    return malang;
  }

  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'ownerid':ownerid,
        'type': type,
        'createdtime':createdtime,
        'price':price,
        'nickname':nickname,
      };
}