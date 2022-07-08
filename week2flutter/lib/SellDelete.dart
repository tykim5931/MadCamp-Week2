import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
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
    var malangidx = args.malangidx;
    var sell = args.sell;

    var _malang = malangList[malangidx];
    var myController = TextEditingController();

    String info = "Lev: ${_malang.type.toString()}, Age: ${_malang.age.toString()}";
    var _visibility = true;
    String btnText = "";

    if (sell){  // 경매
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
            Visibility(
              visible: !_visibility,
              child: Text(
                "정말로 버리시겠습니까?",
                style: const TextStyle(
                fontSize: 40,
              ),
              ),
            ),
            Image.asset(
              _malang.imgsource,
            ),
            Container(
              color: Colors.lightGreenAccent,
              alignment: Alignment.center,
              child: Text(
                info,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),

            // ### Get Name
            Visibility(
              visible: _visibility,
              child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  color: Colors.yellow,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '가격을 정해주세요',
                    ),
                  )
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          return;
                        }
                        // save _malang instance to market table (server)
                        // remove from user (server) (malangidx)
                      }
                      else{ // 방출
                        // remove from user (server) (malangidx)
                      }
                      Navigator.pushNamed(context, '/inventory');
                    },
                    child: Text(btnText)
                ),
              ],
            )
          ],
        )
    );
  }
}