import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;

import 'data/instances.dart';
import 'data/arguments.dart';



List<Malang> malangList = [];

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
                    Navigator.pushNamed(
                        context,
                        '/gotchya',
                      arguments: GotchyaArgument(malangList.length)
                    );
                  },
                  child: Text("갓챠!!")
              ),

              FutureBuilder<List<Malang>>(
                future: serverUtils.getSlimes(_manager.root.id),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                      malangList = snapshot.data!;
                    return Expanded(
                      flex: 2,
                        child: GridView.builder(
                          padding: EdgeInsets.all(10),
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
                                  Image.asset(
                                      SLIMETYPE[malangList.elementAt(idx).type]!["gifsource"]
                                  ),
                                  Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Lev ${malangList.elementAt(idx).type ~/ 3}",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      malangList.elementAt(idx).nickname,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
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

                                      Container(width: 2),
                                      Expanded(
                                        flex:1,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
                                            onPressed: (){
                                              Navigator.pushNamed(
                                                  context,
                                                  '/sellDelete',
                                                  arguments: ScreenArgument(
                                                      malangList[idx],
                                                      true
                                                  )
                                              );
                                            },
                                            child: Text("경매")
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
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