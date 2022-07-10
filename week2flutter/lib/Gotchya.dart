import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  Malang(ownerid: "1",
      type: 3, nickname: "바이러스"),
  Malang(ownerid: "1", type: 4, nickname: "강아지"),
  Malang(ownerid: "1", type: 5, nickname: "재빠른 병아리"),
  Malang(ownerid: "1", type: 6, nickname: "유니콘"),
  Malang(ownerid: "1", type: 7, nickname: "플라워"),
  Malang(ownerid: "1", type: 8, nickname: "잠탱이"),
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

    // 랜덤한 말랑이 타입뽑기.
    var malangtype = Random().nextInt(9);

    var myController = TextEditingController();
    var gotchyaPrice = 100; // dia
    String imgsource = "";
    String info = "";
    var _visibility = true;

    // TODO 임시로 dia = point
    _manager.root.dia = _manager.root.point;

    if (_manager.root.dia < gotchyaPrice){  // 돈 모자람
      info = "안타깝네요! ${gotchyaPrice-_manager.root.dia} \u{1F48E} 더 모아오세요"; //gem stone
      imgsource = "assets/poor.png";
      _visibility = false;
    }
    else{ // 갓챠 실행함
      _manager.root.dia -= gotchyaPrice;
      info = "Lev: ${(malangtype ~/ 3).toString()}, Birth: ${DateTime.now().toString()}";
      imgsource = slimeType[malangtype]![1];
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
              "남은 \u{1F48E}: ${_manager.root.dia}",
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
                      Malang newmalang = Malang(
                        ownerid: _manager.root.id,
                        type: malangtype,
                        nickname: "익명의 슬라임"
                      );
                      if(myController.text.isNotEmpty)
                        newmalang.nickname = myController.text;
                      serverUtils.addSlime(newmalang); // 새로 생성된 말랑이 서버에 요청해서 DB에 적기

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