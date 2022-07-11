import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'data/instances.dart';
import 'server.dart' as serverUtils;

import 'data/arguments.dart';




List<Malang> malangList = [];



class SellDelete extends StatefulWidget{
  SellDelete({Key? key}) : super(key:key);

  @override
  _SellDelete createState() => _SellDelete(); // state 생성
}

class _SellDelete extends State<SellDelete>{
  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArgument;
    Malang _malang = args.malang;
    var sell = args.sell;
    var myController = TextEditingController();

    String descritpion = "정말로 버리시겠습니까?";
    String info = "Name : ${_malang.nickname.toString()}\nLev  : ${_malang.type.toString()} \nBirth: ${_malang.createdtime.toString().substring(0, 10)}";
    var _visibility = true;
    String btnText = "";

    if (sell){  // 경매
      descritpion = "슬라임을 판매합니다.";
      btnText = "내다팔기";
      _visibility = true;
    }
    else{ // 방출
      btnText = "방생하기";
      _visibility = false;
    }

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              descritpion,
              style: const TextStyle(
              fontSize: 30,
            ),
            ),
            Image.asset(
              SLIMETYPE[_malang.type]!["gifsource"],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  info,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
                height: 20
            ),
            // ### Get Name
            Visibility(
              visible: _visibility,
              child: Container(
                  height: 35,
                  width: 250,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '가격을 정해주세요',
                    ),
                  )
              ),
            ),
            Container(
                height: 20
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ElevatedButton(
                    onPressed: (){
                      if(sell == true){ // 경매
                        // 에러 안 나게 숫자인지 try catch 문 만들 것.
                        try{
                          _malang.price = int.parse(myController.text);
                        }catch (e){
                          Fluttertoast.showToast(
                              msg: "0보다 큰 숫자를 입력해 주세요",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP_RIGHT
                          );
                        }
                        serverUtils.updateSlime(_malang);
                      }
                      else{ // 방출
                        serverUtils.deleteSlime(_malang.id);
                      }
                      Navigator.pushNamed(context, '/inventory');
                    },
                    child: Text(btnText)
                ),
                Container(
                  width: 20
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/inventory');
                    },
                    child: Text("뒤로가기")
                ),
              ],
            )
          ],
        )
    );
  }
}