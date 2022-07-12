import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Feed.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;
import 'data/instances.dart';
import 'data/arguments.dart';



class FeedBoard extends StatefulWidget{
  FeedBoard({Key? key}) : super(key:key);

  @override
  _FeedBoard createState() => _FeedBoard(); // state 생성
}

class _FeedBoard extends State<FeedBoard> {

  @override
  Widget build(BuildContext context) {
    UserManager _manager = Provider.of<UserManager>(context, listen: false);

    var future = serverUtils.requireFeedList();
    List<Feed> feedList;
    var table = ['C', 'B', 'A', 'S'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('게시판'),
      ),
      drawer: MyDrawer(),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<List<Feed>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                feedList = snapshot.data!.cast<Feed>();
                return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: feedList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int idx) {
                              // item의 반복문 항목 형성
                              return Container(
                                //color: Colors.yellow,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: new AssetImage("assets/backboard2.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Container(
                                        child: Text(
                                          "${feedList[idx].nickname}",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              SLIMETYPE[feedList[idx]
                                                  .type]!['gifsource'],
                                            fit: BoxFit.fill,

                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Written by. ${feedList[idx].ownerid}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                    color: Colors.grey
                                                  )
                                              ),
                                              Text(
                                                "종: ${SLIMETYPE[feedList[idx]
                                                    .type]!["species"]}\n등급: ${table[(feedList[idx]
                                                    .type ~/ 3)]}\nBirth: ${feedList[idx]
                                                    .createdtime.substring(0, 10)}",
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                          "한줄 소개: ${feedList[idx].line}"
                                      )
                                    ]
                                ),
                              );
                            }, separatorBuilder:
                              (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                          ),
                        )
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'town_FAB1',
              // isExtended: true,
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.lime,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'town_FAB2',
              // isExtended: true,
              child: Icon(Icons.home),
              backgroundColor: Colors.lime,
              onPressed: () {
                var _manager = Provider.of<UserManager>(
                    context, listen: false); // 전역변수
                _manager.selected = _manager.root;
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}