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
    String? username;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('오늘의 득템 자랑!!'),
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
                              return

                                FutureBuilder<List<User>>(
                                  future: serverUtils.requireUser(feedList[idx].ownerid),
                                  builder: (context,snapshot) {
                                    if (snapshot.hasData) {
                                      username = snapshot.data![0].nickname;
                                      return Container(
                                        //color: Colors.yellow,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: new AssetImage("assets/backboard3.png"),
                                                fit: BoxFit.fill
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Container(
                                                 padding: EdgeInsets.only(bottom:10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(10,0,5,5),
                                                      child: Text(
                                                          "${username}의 ${feedList[idx].nickname}",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          )
                                                      ),
                                                    ),
                                                    Flexible(fit: FlexFit.tight, child: SizedBox.shrink()),
                                                    Container(
                                                      padding: EdgeInsets.only(bottom: 3),
                                                      child: Text(
                                                        "${feedList[idx].likes}",
                                                        style: TextStyle(
                                                        fontSize:20,
                                                      )
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(0,0,5,5),
                                                      child: IconButton(

                                                          onPressed: (){
                                                            setState((){
                                                              feedList[idx].likes = feedList[idx].likes+1;
                                                              serverUtils.updateFeed(feedList[idx]);
                                                            });
                                                          },
                                                          icon: Icon(Icons.favorite)
                                                      ),
                                                    )
                                                  ],
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
                                                    width:100,height: 100,
                                                  ),
                                                  Container(
                                                    padding : EdgeInsets.fromLTRB(10,20,0,0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            "Written by. ${feedList[idx].ownerid}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.grey
                                                            )
                                                        ),
                                                        Text(
                                                          "종   : ${SLIMETYPE[feedList[idx]
                                                              .type]!["species"]}\n등급 : ${table[(feedList[idx]
                                                              .type ~/ 3)]}\nBirth: ${feedList[idx]
                                                              .createdtime.substring(0, 10)}",
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                  "한줄 소개: ${feedList[idx].line}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              )
                                            ]
                                        ),
                                      );


                                    } else if (snapshot.hasData == false) {
                                      return Container(width:50, height:50, child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Text('스냅샷 에러');
                                    } else {
                                      return Text('혹시 몰라서 else문 추가');
                                    }
                                  },
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