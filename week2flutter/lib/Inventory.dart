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

class Inventory extends StatefulWidget{
  Inventory({Key? key}) : super(key:key);

  @override
  _Inventory createState() => _Inventory(); // state 생성
}

class _Inventory extends State<Inventory>{
  // 인벤토리는 항상 root user의 슬라임 리스트를 불러와 보여준다.
  // 갓챠를 통해 add될 경우

  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    User currUser = _manager.root;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('인벤토리'),
        ),
        drawer: MyDrawer(),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/gotchya');
                  },
                  child: Text("갓챠!!")
              ),
              Expanded(child: GridView.builder(
                  itemCount: malangList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1/2, // 가로/세로 비율
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int idx){
                    // item의 반복문 항목 형성
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Visibility(
                              child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(
                                        context,
                                        '/sellDelete',
                                        arguments: ScreenArgument(
                                            idx,
                                            false
                                        ));
                                    },
                                  child: Text("방출")
                              ),
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.pushNamed(
                                      context,
                                      '/sellDelete',
                                      arguments: ScreenArgument(
                                          idx,
                                          true
                                      ));
                                },
                                child: Text("경매")
                            ),
                          ],
                        ),
                        Image.asset(
                            malangList.elementAt(idx).imgsource
                        ),
                        Container(
                          height: 20,
                          alignment: Alignment.center,
                          color: Colors.yellow,
                          child: Text(
                            '$idx',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.lightGreenAccent,
                          alignment: Alignment.center,
                          child: Text(
                            malangList.elementAt(idx).name,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ))
            ],
          )
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
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

class ScreenArgument{
  final int malangidx;
  final bool sell;
  ScreenArgument(this.malangidx, this.sell);
}