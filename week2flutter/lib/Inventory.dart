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
  Malang(ownerid: "1", type: 3, nickname: "바이러스"),
  Malang(ownerid: "1", type: 4, nickname: "강아지"),
  Malang(ownerid: "1", type: 5, nickname: "재빠른 병아리"),
  Malang(ownerid: "1", type: 6, nickname: "유니콘"),
  Malang(ownerid: "1", type: 7, nickname: "플라워"),
  Malang(ownerid: "1", type: 8, nickname: "잠탱이"),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/gotchya');
                  },
                  child: Text("갓챠!!")
              ),

              FutureBuilder<List<Malang>>(
                future: serverUtils.getSlimes(_manager.root.id),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                      malangList = snapshot.data!;
                    return SizedBox(
                      height: 500,
                        child: Column(
                      children: [
                        Expanded(
                            child: GridView.builder(
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
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pushNamed(
                                                      context,
                                                      '/sellDelete',
                                                      arguments: ScreenArgument(
                                                          malangList[idx],
                                                          false
                                                      ));
                                                },
                                                child: Text("방출")
                                            ),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pushNamed(
                                                      context,
                                                      '/sellDelete',
                                                      arguments: ScreenArgument(
                                                          malangList[idx],
                                                          true
                                                      ));
                                                },
                                                child: Text("경매")
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                          slimeType[malangList.elementAt(idx).type]![1]
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
                                          malangList.elementAt(idx).nickname,
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
                    ));
                  } else if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('스냅샷 에러');
                  } else {
                    return Text('혹시 몰라서 else문 추가');
                  }
                },
              ),
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
              heroTag: 'inv_FAB1',
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
              heroTag: 'inv_FAB2',
              // isExtended: true,
              child: Icon(Icons.home),
              backgroundColor: Colors
                  .lime,
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
  final Malang malang;
  final bool sell;
  ScreenArgument(this.malang, this.sell);
}