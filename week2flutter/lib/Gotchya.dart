import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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


class Gotchya extends StatefulWidget{
  Gotchya({Key? key}) : super(key:key);

  @override
  _Gotchya createState() => _Gotchya(); // state 생성
}

class _Gotchya extends State<Gotchya>{
  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    var myController = TextEditingController();
    var randomMalang = malangList[Random().nextInt(9)];
    var gotchyaPrice = 100 * _manager.root.gotchya;  // 많이 하면 할수록 비싸짐.
    String imgsource = "";
    String info = "";
    var _visibility = true;

    if (_manager.root.point < gotchyaPrice){  // 돈 모자람
      info = "안타깝네요! ${gotchyaPrice-_manager.root.point}P 더 모아오세요";
      imgsource = "assets/poor.png";
      _visibility = false;
    }
    else{ // 갓챠 실행함
      _manager.root.point -= gotchyaPrice;
      _manager.root.gotchya += 1;
      info = "Lev: ${randomMalang.type.toString()}, Age: ${randomMalang.age.toString()}";
      imgsource = randomMalang.imgsource;
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
              imgsource,
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

          Container(
            color: Colors.lightGreenAccent,
            alignment: Alignment.center,
            child: Text(
              "남은 포인트: ${_manager.root.point}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          // ### Get Name
          Visibility(
            visible: _visibility,
            child: Container(
                height: 40,
                alignment: Alignment.center,
                color: Colors.yellow,
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름을 지어주세요',
                  ),
                )
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Visibility(
                visible: _visibility,
                child: ElevatedButton(
                    onPressed: (){
                      randomMalang.name = myController.text;
                      // 새로 생성된 말랑이 서버에 요청해서 DB에 적기
                      Navigator.pushNamed(context, '/inventory');
                    },
                    child: Text("OK!")
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/inventory');
                  },
                  child: Text("돌아갈래요")
              ),
            ],
          )
        ],
      )
    );
  }
}