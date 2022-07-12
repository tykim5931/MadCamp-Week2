import 'dart:convert';

import 'package:flutter/material.dart';
import 'data/Feed.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'package:http/http.dart' as http;

String _url = "http://192.249.18.162:80";


// #### USER ######
Future<List<User>> requireUser(String id) async { // 아이디로 유저 요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/user"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'userid': id})
  );
  print(_res.body);
  var parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

Future<List<User>> searchUser(String text) async { // 아이디로 유저 요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/searchuser"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'searchid': text})
  );
  final parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();  //List<User>
}

Future<User> updateUser(User user) async { // 유저 업데이트
  http.Response _res =
  await http.post(
      Uri.parse("$_url/userupdate"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(user.toJson())
  );
  print(_res.body);
  return  User.fromJson(jsonDecode(_res.body));
}

Future<User> addUser(User user) async { // 유저 업데이트
  http.Response _res =
  await http.post(
      Uri.parse("$_url/useradd"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(user.toJson())
  );
  print(_res.body);
  return  User.fromJson(jsonDecode(_res.body));
}

Future<List<User>> reqireUserList() async { // 유저 리스트 요청
  http.Response _res =
  await http.get(
      Uri.parse("$_url/users"),
      headers: {
        "Content-Type": "application/json",
      }
  );
  // print(_res.body);
  var parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();  //List<User>
}


//##### SLIME #######

Future<List<Malang>> getSlimes(String id) async { // 유저의 슬라임 요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/getslimes"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({'userid': id})
  );
  print(_res.body);
  final parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<Malang>((json) => Malang.fromJson(json)).toList();  //List<Malang>
}

void updateSlime(Malang malang) async { // 슬라임 업데이트 요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/editslime"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(malang.toJson())
  );
  print(_res.body);
}

void addSlime(Malang malang) async { // 새로운 슬라임 추가요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/addslime"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(malang.toJson())
  );
  print(_res.body);
}

Future<List<Malang>> allSlimes() async { // 마켓에서 모든 존재하는 슬라임 리스트 요청.
  http.Response _res =
  await http.get(
      Uri.parse("$_url/market"),
      headers: {
        "Content-Type": "application/json",
      },
  );
  final parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<Malang>((json) => Malang.fromJson(json)).toList();  //List<Malang>
}

Future<List<Malang>> sortedSlimes(String sortby, String asc) async { // 정렬된 슬라임 리스트 요청
  http.Response _res =
  await http.post(
    Uri.parse("$_url/sortslime"),
      headers: {
        "Content-Type": "application/json",
      },
    body: json.encode({"sortby" : sortby,"asc" : asc })
  );
  final parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<Malang>((json) => Malang.fromJson(json)).toList();  //List<Malang>
}

void deleteSlime(int id) async { // 슬라임 삭제 요청
  http.Response _res =
  await http.post(
      Uri.parse("$_url/deleteslime"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"id" : id})
  );
}

void addFeed(Feed feed) async { // 피드에 추가
  http.Response _res =
  await http.post(
      Uri.parse("$_url/feedadd"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(feed.toJson())
  );
  print(_res.body);
}

Future<List<Feed>> requireFeedList() async { // 유저 리스트 요청
  http.Response _res =
  await http.get(
      Uri.parse("$_url/getfeed"),
      headers: {
        "Content-Type": "application/json",
      }
  );
  // print(_res.body);
  var parsed = json.decode(_res.body).cast<Map<String, dynamic>>();
  return parsed.map<Feed>((json) => Feed.fromJson(json)).toList();  //List<User>
}