import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';

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


class Market extends StatefulWidget{
  Market({Key? key}) : super(key:key);

  @override
  _Market createState() => _Market(); // state 생성
}

class _Market extends State<Market>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('슬라임 마켓'),
      ),
      drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                          malangList.elementAt(idx).imgsource,
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
                                  "Name: ${malangList.elementAt(idx).name}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Age: ${malangList.elementAt(idx).age} D",
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