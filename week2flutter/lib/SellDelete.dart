import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;



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

    String info = "Lev: ${_malang.type.toString()}, Birth: ${_malang.createdtime.toString()}";
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
              slimeType[_malang.type]![1],
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
              ],
            )
          ],
        )
    );
  }
}