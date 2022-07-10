import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'server.dart' as serverUtils;
import 'package:fluttertoast/fluttertoast.dart';

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
                  ElevatedButton(
                      onPressed: (){
                        future = serverUtils.sortedSlimes("type", "desc");
                        },
                      child: Text("레벨높은순")
                  ),
                  ElevatedButton(
                      onPressed: (){
                        future = serverUtils.sortedSlimes("type", "asc");
                      },
                      child: Text("레벨낮은순")
                  ),
                  ElevatedButton(
                      onPressed: (){
                        future = serverUtils.sortedSlimes("price", "desc");
                      },
                      child: Text("가격높은순")
                  ),
                  ElevatedButton(
                      onPressed: (){
                        future = serverUtils.sortedSlimes("price", "asc");
                      },
                      child: Text("가격낮은순")
                  )
                ]
            ),

            FutureBuilder<List<Malang>>(
              future: future,
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  malangList = snapshot.data!;
                  return SizedBox(
                      height: 200,
                      child: Expanded(
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
                                      slimeType[malangList.elementAt(idx).type]![1],
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child:Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.blue,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Name: ${malangList.elementAt(idx).nickname}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Age: ${malangList.elementAt(idx).createdtime} D",
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Price: ${malangList.elementAt(idx).price} P",
                                              style: const TextStyle(
                                                fontSize: 15,
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
                                        onPressed: (){
                                          Malang malang = malangList.elementAt(idx);
                                          if(_manager.root.point >= malang.price){
                                            setState((){
                                              malang.ownerid = _manager.root.id;
                                              _manager.root.point = _manager.root.point - malang.price;
                                              malang.price = 0;
                                              serverUtils.updateUser(_manager.root);
                                              serverUtils.updateSlime(malang);
                                              Fluttertoast.showToast(
                                                  msg: "입양 완료! ${_manager.root.point}P 남았어요",
                                                  // backgroundColor: Colors.white,
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER);
                                            });
                                          }
                                          else{
                                            Fluttertoast.showToast(
                                                msg: "돈이 모자라요... 더 벌어서 다시 와주세요!",
                                                // backgroundColor: Colors.white,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          }
                                          // 이 아이템의 소유주 ID를 변경시켜 줌.
                                          // 아이템의 소유주 변경 요청을 보내야 함.
                                          // 소유주 변경은 서버에서 일어남.
                                          // Toast로 구매완료, 남은 포인트 알려주고
                                          // refresh. 서버에서 다시 읽어오기
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
                      )
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
