import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Global/MyGame.dart';
import 'package:week2flutter/Global/UserManager.dart';
import 'package:week2flutter/MyDrawer.dart';
import 'dart:math';
import 'package:floating_text/floating_text.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'data/Malang.dart';
import 'data/User.dart';



List<Malang> malangList = [
  Malang(type: 0, name: "플레인", imgsource: "assets/plain.gif"),
  Malang(type: 1, name: "물방울", imgsource: "assets/waterdrop.gif"),
  Malang(type: 2, name: "오로라", imgsource: "assets/ourora.gif"),
  Malang(type: 3, name: "바이러스", imgsource: "assets/vvirus.gif"),
  Malang(type: 4, name: "강아지", imgsource: "assets/puppy.gif"),
  Malang(type: 5, name: "재빠른 병아리", imgsource: "assets/fastchick.gif"),
  Malang(type: 6, name: "유니콘", imgsource: "assets/unicorn.gif"),
  Malang(type: 7, name: "플라워", imgsource: "assets/flower.gif"),
  Malang(type: 8, name: "잠탱이", imgsource: "assets/sleepy.gif"),
];


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
          title: Text("${_manager.selected.id}의 슬라임 농장"),
        ),
      drawer: MyDrawer(),
      body: Container(
        child: GestureDetector(
          onTap: (){ // user의 슬라임 리스트 가지고 포인트 계산
            if(_manager.selected.id == _manager.root.id) {
              _manager.root.addPoint(1);
            }
            print(_manager.root.point);
            },
            child:GameWidget(game: MyGame()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
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
