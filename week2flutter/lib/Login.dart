import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/data/instances.dart';

import 'Global/KakaoLogin.dart';
import 'Global/UserManager.dart';
import 'data/User.dart' as myUser;
import 'server.dart' as serverUtils;


class Login extends StatefulWidget{
  Login({Key? key}) : super(key:key);

  @override
  _Login createState() => _Login(); // state 생성
}

class _Login extends State<Login>{
  // final viewModel = ViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {{
    ViewModel viewModel = Provider.of<ViewModel>(context, listen: false);
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    var id = null;
    var nickname  = null;

    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    // '${viewModel.isLogined}',
                    "Welcome to",
                    style: TextStyle(
                      color: Colors.lime,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    // '${viewModel.isLogined}',
                    "MalangMalang",
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(SLIMETYPE[Random().nextInt(SLIMETYPE.length)]!["gifsource"]),
            ElevatedButton(
                onPressed: () async {
                  await viewModel.login();

                  // Check if user is there & add if there isn't
                  id = viewModel.user?.id.toString();
                  nickname = viewModel.user?.kakaoAccount?.profile?.nickname;
                  _manager.root = myUser.User(id: id, nickname: nickname);  // if user doesn't agree nickname providng, then nickname must be null

                  // ASK server
                  serverUtils.addUser(_manager.root); // if user didn't agree nickname but was created before, then here comes custom nickname
                  var future = serverUtils.requireUser(id);
                  future.then((val) {
                    _manager.root = val[0];
                    _manager.selected = _manager.root;
                    Navigator.pushNamedAndRemoveUntil(context, '/',(r)=>false);
                  }).catchError((error) {
                    print('error: $error');
                  });
                },
              child: Text('카카오톡으로 로그인하기',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal)),
            ),
          ]
        )
      )
    );
  }
}}