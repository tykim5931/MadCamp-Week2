import 'dart:io';
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

    var profile = NetworkImage(viewModel.user?.kakaoAccount?.profile?.profileImageUrl  ??  '');

    return Scaffold(
        body:Container(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '닉네임 변경하기',
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Container(
                        height: 20
                    ),
                    Container(
                      height:80,
                      width:80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl  ??  ''),
                      ),
                    ),
                    Container(
                        height: 20
                    ),
                    Container(
                        height: 35,
                        width: 250,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '닉네임을 정해주세요',
                          ),
                        )
                    ),
                    Container(
                        height: 20
                    ),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              _manager.root.nickname = myController.text;
                              serverUtils.updateUser(_manager.root);
                              _manager.selected = _manager.root;
                              Navigator.pushNamedAndRemoveUntil(context, '/', (r)=>false);
                            },
                            child: const Text('완료')),
                        Container(
                            width: 20
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if(_manager.root.nickname == null){
                                _manager.root.nickname = "익명의 전사";
                              }
                              serverUtils.updateUser(_manager.root);
                              _manager.selected = _manager.root;
                              Navigator.pushNamedAndRemoveUntil(context, '/', (r)=>false);
                            },
                            child: const Text('취소')),
                      ],
                    ),
                  ]
              )
          ),
        )
    );
  }
  }}