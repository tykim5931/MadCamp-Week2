import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Inventory.dart';
import 'Global/KakaoLogin.dart';
import 'Global/UserManager.dart';
import 'MyDrawer.dart';
import 'data/Malang.dart';
import 'data/User.dart';
import 'server.dart' as serverUtils;



class EditNickname extends StatefulWidget{
  EditNickname({Key? key}) : super(key:key);

  @override
  _EditNickname createState() => _EditNickname(); // state 생성
}

class _EditNickname extends State<EditNickname>{

  @override
  Widget build(BuildContext context) {{
    ViewModel viewModel = Provider.of<ViewModel>(context, listen: false);
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    var myController = TextEditingController();

    return Scaffold(
        body:Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/waterdrop.gif'),
                  // Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl  ??  ''),
                  Text(
                    '닉네임 변경',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                      height: 30,
                      alignment: Alignment.center,
                      color: Colors.yellow,
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '닉네임을 정해주세요',
                        ),
                      )
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            _manager.root.nickname = myController.text;
                            serverUtils.updateUser(_manager.root);

                            setState(() {});
                            _manager.selected = _manager.root;
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text('완료')),
                      ElevatedButton(
                          onPressed: () async {
                            if(_manager.root.nickname == null){
                              _manager.root.nickname = "익명의 전사";
                            }
                            serverUtils.updateUser(_manager.root);
                            _manager.selected = _manager.root;
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text('취소')),
                    ],
                  ),
                ]
            )
        )
    );
  }
  }}