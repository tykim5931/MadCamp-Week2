import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'package:week2flutter/data/instances.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;
import 'data/arguments.dart';



List<Malang> malangList = [];


class Gotchya extends StatefulWidget{
  Gotchya({Key? key}) : super(key:key);

  @override
  _Gotchya createState() => _Gotchya(); // state 생성
}

class _Gotchya extends State<Gotchya>{
  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as GotchyaArgument;
    int currLen = args.malanglength;

    // update user state
    var future1 = serverUtils.requireUser(_manager.root.id);
    future1.then((val) {
      _manager.root = val[0]; // 중간에 다른 유저가 매물을 사면서 내 포인트가 늘어나게 되는 상황 대비!!
    }).catchError((error) {
      print('error: $error');
    });

    // 랜덤한 말랑이 타입뽑기.
    var probalist = USERLEVEL[_manager.root.level]!["probalist"]; // proba of malanglevel
    var totalsum = 0;
    for (int i in probalist){
      totalsum = totalsum+i;
    }
    int level = 0;
    var randint = Random().nextInt(totalsum);
    for (int i =0; i<probalist.length; i++){
      int prob = probalist[i];
      randint = randint - prob;
      if(randint <= 0){
        level = i;
        break;
      }
    }
    int malangtype = level*3 + Random().nextInt(3); // 같은 레벨의 말랑이 3개씩!!
    print(malangtype);

    var myController = TextEditingController();
    var gotchyaPrice = 3; // dia
    String imgsource = "";
    String info = "";
    String btn1 = "OK!";
    var _visibility = true;

    if(currLen >= (USERLEVEL[_manager.root.level]!["inventory"] as num)){ // 인벤토리 가득참
      info = "인벤토리가 가득 찼어요! \n레벨업하거나 슬라임을 내보내고 다시 뽑으세요!";
      imgsource = "assets/full.png";
      btn1 = "레벨업하러 가기";
      _visibility = false;
    }
    else if (_manager.root.dia < gotchyaPrice){  // 돈 모자람
      info = "안타깝네요! ${gotchyaPrice-_manager.root.dia}\u{1F48E} 더 모아오세요"; //gem stone
      imgsource = "assets/poor.png";
      btn1 = "광고보고 3\u{1F48E}";
      _visibility = false;
    }
    else{ // 갓챠 실행함
      _manager.root.dia -= gotchyaPrice;
      var table = ['C','B','A','S'];
      info = "등급: ${table[(malangtype ~/ 3)]}, Birth: ${DateTime.now().toString().substring(0,10)}";
      imgsource = SLIMETYPE[malangtype]!["gifsource"];
    }
    serverUtils.updateUser(_manager.root);  // 갓챠를 했으면 무조건 돈은 사용되는거임.

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
              imgsource,
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "남은 \u{1F48E}: ${_manager.root.dia}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
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
                    labelText: '이름을 지어주세요',
                  ),
                )
            ),
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              ElevatedButton(
                  onPressed: (){
                    if(btn1 == 'OK!'){  // 갓챠 실행됨
                      Malang newmalang = Malang(
                          ownerid: _manager.root.id,
                          type: malangtype,
                          nickname: "익명의 슬라임"
                      );  //Birth 는 내부적으로 생성됨.
                      if(myController.text.isNotEmpty)
                        newmalang.nickname = myController.text;
                      serverUtils.addSlime(newmalang); // 새로 생성된 말랑이 서버에 요청해서 DB에 적기// 유저 업데이트하기
                      Navigator.pushNamedAndRemoveUntil(context, '/inventory', (r)=>false);
                    } else if( btn1 == '레벨업하러 가기'){
                      Navigator.pushNamedAndRemoveUntil(context, '/levelup', (r)=>false);
                    } else{
                      _manager.root.dia = _manager.root.dia + 3;
                      serverUtils.updateUser(_manager.root);

                      sleep(Duration(seconds:1));
                      Fluttertoast.showToast(
                          msg: "광고 보기를 완료하여 3\u{1F48E}를 얻었습니다.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP_RIGHT
                      );
                      Navigator.pushNamedAndRemoveUntil(context, '/inventory', (r)=>false);
                    }
                  },
                  child: Text(btn1)
              ),
              Container(width: 10,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/inventory', (r)=>false);
                  },
                  child: Text("돌아갈래요")
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: CustomFabLoc(),
      floatingActionButton:  Visibility(
        visible: _visibility,
        child: FloatingActionButton.extended(
                heroTag: 'gotcha_FAB1',
                backgroundColor: Color(0xFFE38BFF),
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/',(r)=>false);
                }, label: Column( children: [Icon(Icons.send), Text('자랑하기')],

        ),
              ),
      ),
    );
  }
}

class CustomFabLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * .63, ///customize here
      scaffoldGeometry.scaffoldSize.height * .25,
    );
  }
}



