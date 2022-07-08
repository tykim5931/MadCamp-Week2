import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Global/MyGame.dart';
import 'package:week2flutter/Global/UserManager.dart';
import 'package:week2flutter/MyDrawer.dart';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'data/User.dart';

class Home extends StatefulWidget{
  Home({Key? key}) : super(key:key);

  @override
  _HomeState createState() => _HomeState(); // state 생성
}

class _HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    User currUser = _manager.selected;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${currUser.id}의 슬라임 농장"),
        ),
      drawer: MyDrawer(),
      body:
        Column(
          children: [
            Expanded(
              child:GameWidget(game: MyGame()), // Game widget
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  FloatingActionButton(
                    child: Icon(Icons.shopping_cart),
                    onPressed: (){
                      Navigator.pushNamed(context, '/market');
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.inventory),
                    onPressed: (){
                      Navigator.pushNamed(context, '/inventory');
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.group),
                    onPressed: (){
                      Navigator.pushNamed(context, '/town');
                    },
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}