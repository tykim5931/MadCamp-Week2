import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/data/instances.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;


late List<User> userList;


class Town extends StatefulWidget{
  Town({Key? key}) : super(key:key);

  @override
  _Town createState() => _Town(); // state 생성
}

class _Town extends State<Town>{
  var future = serverUtils.reqireUserList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('이웃들'),
      ),
      drawer: MyDrawer(),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.text,
            onChanged: (text){
              setState(() {
                print("searching...");
                future = serverUtils.searchUser(text);
              });
              },
            decoration: InputDecoration(
                hintText: "검색",
                border: InputBorder.none,
                icon: Padding(
                    padding: EdgeInsets.only(left: 13),
                    child: Icon(Icons.search))),
          ),
          FutureBuilder<List<User>>(
              future: future,
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  userList = snapshot.data!;
                  return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                          child: ListView.separated(
                              itemCount: userList.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int idx){
                                // item의 반복문 항목 형성
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          "assets/images/thumbnail_${userList[idx].level}.png",
                                          // USERLEVEL[userList[idx].level]!["thumbnail"],
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10,0,10,10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Nickname: ${userList.elementAt(idx).nickname}",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10,0,10,10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Level   : ${userList.elementAt(idx).level}",
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
                                      flex: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: (){
                                            var _manager = Provider.of<UserManager>(context, listen: false); // 전역변수
                                            _manager.selected = userList.elementAt(idx);
                                            Navigator.pushNamed(context, '/');
                                          },
                                          child: const Text(
                                            "방문하기",
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }, separatorBuilder:
                              (BuildContext context, int index) { return Divider(thickness: 1);},
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
              onPressed: (){
                Navigator.pushNamed(context, '/');
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