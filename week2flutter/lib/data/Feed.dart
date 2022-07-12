import 'dart:ffi';
import 'package:flutter/material.dart';

class Feed {
  int id = -1; // 얘도 slime처럼 그냥 -1로 놓으면 됨
  String ownerid; // ~~~의 갓챠임을 나타냄
  int type; // 슬라임의 종류
  String createdtime = DateTime.now().toString(); // 언제 뽑았는지(->게시글 작성일과 비슷)
  String nickname; // 갓챠로 뽑은 슬라임의 이름!
  String line = "Gotcha!"; // 한줄 자랑글
  int likes = 0;

  Feed({ // 4가지 받도록 함
    required this.ownerid,
    required this.type,
    required this.nickname,
  });

  int getType(){
    return this.type;
  }
  void setLine(String line){
    this.line = line;
  }

  factory Feed.fromJson(Map<String, dynamic> json) {
    Feed feed = Feed(
        ownerid: json['ownerid'] as String,
        nickname: json['nickname'] as String,
        type: json['type'] as int,
    );
    feed.line = json['line'] as String;
    feed.createdtime = json['createdtime'] as String;
    feed.id = json['id'] as int;
    feed.likes = json['likes'] as int;
    return feed;
  }

  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'ownerid':ownerid,
        'type': type,
        'createdtime':createdtime,
        'nickname':nickname,
        'line':line,
        'likes':likes,
      };
}