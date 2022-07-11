import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'package:week2flutter/data/instances.dart';
import 'Global/KakaoLogin.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;



class LevelUp extends StatefulWidget{
  LevelUp({Key? key}) : super(key:key);

  @override
  _LevelUp createState() => _LevelUp(); // state 생성
}

class _LevelUp extends State<LevelUp>{

  @override
  Widget build(BuildContext context) {{
    ViewModel viewModel = Provider.of<ViewModel>(context, listen: false);
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    var _visibility = true;

    int price;
    String inform;
    int lev = _manager.root.level + 1;

    if(lev == 10) { // 9단계 다음은 없음.
      price = 0;
      inform = "더 올라갈 레벨이 없습니다!";
      _visibility = false;
    }
    else{
      price = USERLEVEL[lev]!["price"];
      inform = "${price}P를 지불하고 Level Up 하시겠습니까?";
    }

    return Scaffold(
        body:Center(
            child: Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: 50),
                    Image.asset("assets/level.png"),
                    Text(inform,
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Visibility(
                          visible: _visibility,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_manager.root.point >= price) {
                                  _manager.root.level = _manager.root.level + 1;
                                  _manager.root.point =
                                      _manager.root.point - price;
                                  serverUtils.updateUser(_manager.root);
                                  setState(() {});
                                  _manager.selected = _manager.root;
                                  Navigator.pushNamed(context, '/');
                                  Fluttertoast.showToast(
                                      msg: "렙업 완료! ${_manager.root.point}P 남았어요",
                                      // backgroundColor: Colors.white,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER);
                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: "포인트가 모자랍니다. ${price -
                                          _manager.root.point}P 더 모으세요",
                                      // backgroundColor: Colors.white,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER);
                                }
                              },
                              child: const Text('렙업할래요')
                              ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              _manager.selected = _manager.root;
                              Navigator.pushNamed(context, '/');
                            },
                            child: const Text('돌아가기')),
                      ],
                    ),
                  ]
              ),
            )
        )
    );
  }
  }}