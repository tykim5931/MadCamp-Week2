import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/data/instances.dart';
import 'Global/UserManager.dart';
import 'Inventory.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'server.dart' as serverUtils;
import 'package:fluttertoast/fluttertoast.dart';

import 'data/arguments.dart';



List<Malang> malangList = [];

class Market extends StatefulWidget{
  Market({Key? key}) : super(key:key);

  @override
  _Market createState() => _Market(); // state 생성
}

class _Market extends State<Market>{
  var future = serverUtils.allSlimes();

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('슬라임 마켓'),
      ),
      drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: (){
                          future = serverUtils.sortedSlimes("type", "desc");
                          setState((){});
                          },
                        child: Text("레벨높은순")
                    ),
                  ),
                  Expanded(
                    flex:1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                      onPressed: (){
                        future = serverUtils.sortedSlimes("type", "asc");
                        setState((){});
                      },
                      child: Text("레벨낮은순")
                  ),
                  ),
                  Expanded(
                    flex:1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                      onPressed: (){
                        future = serverUtils.sortedSlimes("price", "desc");
                        setState((){});
                      },
                      child: Text("가격높은순")
                  ),
                  ),
                  Expanded(
                      flex:1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                      onPressed: (){
                        future = serverUtils.sortedSlimes("price", "asc");
                        setState((){});
                      },
                      child: Text("가격낮은순")
                  )
                  ),
                ]
            ),

            FutureBuilder<List<Malang>>(
              future: future,
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  malangList = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: malangList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int idx){
                          // item의 반복문 항목 형성
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Expanded(flex: 1,child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  SLIMETYPE[malangList.elementAt(idx).type]!["gifsource"],
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              ),
                              Expanded(
                                flex: 2,
                                child:Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Name : ${malangList.elementAt(idx).nickname}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          "Birth: ${malangList.elementAt(idx).createdtime.substring(0, 10)}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          "Price: ${malangList.elementAt(idx).price} P",
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                                    onPressed: (){
                                      Malang malang = malangList.elementAt(idx);
                                      if(currLen >= USERLEVEL[_manager.root.level]!["inventory"]){
                                        Fluttertoast.showToast(
                                            msg: "인벤토리가 가득 찼습니다!",
                                            // backgroundColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER);
                                      }
                                      else if(_manager.root.point < malang.price){
                                        print(_manager.root.point);
                                        Fluttertoast.showToast(
                                            msg: "돈이 모자라요... 더 벌어서 다시 와주세요!",
                                            // backgroundColor: Colors.white,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER);
                                      }
                                      else{
                                        setState((){
                                          malangList.removeAt(idx); // 보여지는 마켓 리스트에서 말랑이 삭제.
                                          var oldid = malang.ownerid;
                                          var future = serverUtils.requireUser(oldid);  // 판매자 불러오기
                                          future.then((val) {
                                            var seller = val[0];
                                            seller.point = seller.point + malang.price; //판매자의 point 증가
                                            print(seller.point);
                                            serverUtils.updateUser(seller); // 판매자 정보 업데이트

                                            malang.ownerid = _manager.root.id;  // 말랑이의 소유권 이전
                                            _manager.root.point = _manager.root.point - malang.price; // 돈을 사용
                                            malang.price = 0; // 말랑이의 가격 리셋
                                            serverUtils.updateUser(_manager.root);
                                            serverUtils.updateSlime(malang);  // 만약 소유권이전시에는 원 소유자에 찾아가서 point더해줄 것!!
                                            Fluttertoast.showToast(
                                                msg: "입양 완료! ${_manager.root.point}P 남았어요",
                                                // backgroundColor: Colors.white,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          }).catchError((error) {
                                            print('error: $error');
                                          });
                                        });
                                      }
                                    },
                                    child: const Text(
                                      "입양하기",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
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
            )],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'market_FAB1',
              // isExtended: true,
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.lime,
              onPressed: (){
                Navigator.pushNamed(context, '/');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'market_FAB2',
              // isExtended: true,
              child: Icon(Icons.home),
              backgroundColor: Colors.lime,
              onPressed: (){
                var _manager = Provider.of<UserManager>(context, listen: false); // 전역변수
                _manager.selected = _manager.root;
                Navigator.pushNamed(context, '/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
