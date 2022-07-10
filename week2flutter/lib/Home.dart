
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Global/MyGame.dart';
import 'package:week2flutter/Global/UserManager.dart';
import 'package:week2flutter/MyDrawer.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:floating_text/floating_text.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;

import 'package:socket_io_client/socket_io_client.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';



List<Malang> malangList = [
  Malang(ownerid: "1", type: 0, nickname: "플레인"),
  Malang(ownerid: "1", type: 1, nickname: "물방울"),
  Malang(ownerid: "1", type: 2, nickname: "오로라"),
  Malang(ownerid: "1", type: 3, nickname: "바이러스"),
  Malang(ownerid: "1", type: 4, nickname: "강아지"),
  Malang(ownerid: "1", type: 5, nickname: "재빠른 병아리"),
  Malang(ownerid: "1", type: 6, nickname: "유니콘"),
  Malang(ownerid: "1", type: 7, nickname: "플라워"),
  Malang(ownerid: "1", type: 8, nickname: "잠탱이"),
];


UserManager _manager = UserManager();

late Socket socket;
String _url = "http://192.249.18.162:80";

class Home extends StatefulWidget{
  Home({Key? key}) : super(key:key);

  @override
  _HomeState createState() => _HomeState(); // state 생성
}

class _HomeState extends State<Home>{


  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${_manager.selected.nickname}의 슬라임 농장"),
        ),
      drawer: MyDrawer(),
      body:Center(
        child: FutureBuilder<List<Malang>>(
          future: serverUtils.getSlimes(_manager.selected.id),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              malangList = snapshot.data!;
              return Container(
                child: GestureDetector(
                  onTap: (){ // user의 슬라임 리스트 가지고 포인트 계산
                    if(_manager.selected.id == _manager.root.id) {
                      _manager.root.addPoint(calcPoint(malangList));
                      serverUtils.updateUser(_manager.root);  // TODO update user !! 여기 타입변경이 문제될 수 있음
                    }
                  },
                  child:GameWidget(game: MyGame(context: context, malangList: malangList)),
                ),
              );
            } else if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('스냅샷 에러');
            } else {
              return Text('혹시 몰라서 else문 추가');
            }
            },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton:
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'home_FAB0',
                  child: Icon(Icons.message),
                  onPressed: () {
                    setState(() {
                      serverUtils.addSlime(Malang(ownerid: "test1", type: 0, nickname: "플레인"));
                    });
                  },
                ),
                FloatingActionButton(
                  heroTag: 'home_FAB1',
                  child: Icon(Icons.shopping_cart),
                  onPressed: (){
                    Navigator.pushNamed(context, '/market');
                  },
                ),
                FloatingActionButton(
                  heroTag: 'home_FAB2',
                  child: Icon(Icons.inventory),
                  onPressed: (){
                    Navigator.pushNamed(context, '/inventory');
                  },
                ),
                FloatingActionButton(
                  heroTag: 'home_FAB3',
                  child: Icon(Icons.group),
                  onPressed: (){
                    Navigator.pushNamed(context, '/town');
                  },
                ),
              ],
            ),
          )
    );

  }
}

int calcPoint(List<Malang> malanglist){
  int point = 0;
  if(malanglist.isEmpty)
    return 1;
  for (int i = 0; i < malanglist.length; i++){
    point = point + ((malanglist[i].type) ~/ 3 +1); // 3개씩 같은 레벨.
  }
  return point;
}