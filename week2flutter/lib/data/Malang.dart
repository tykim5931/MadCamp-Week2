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

Map<int, List<String>> slimeType =
{ 0: ["플레인", "assets/plain.gif"],
  1: ["물방울","assets/waterdrop.gif"],
  2: ["오로라","assets/ourora.gif"],
  3: ["바이러스","assets/vvirus.gif"],
  4: ["강아지","assets/puppy.gif"],
  5: ["재빠른병아리","assets/fastchick.gif"],
  6: ["유니콘","assets/unicorn.gif"],
  7: ["플라워","assets/flower.gif"],
  8: ["잠탱이","assets/sleepy.gif"]
};