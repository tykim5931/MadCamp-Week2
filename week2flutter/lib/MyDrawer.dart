import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Global/KakaoLogin.dart';
import 'Global/UserManager.dart';


class MyDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    ViewModel viewModel = Provider.of<ViewModel>(context, listen: false);
    UserManager _manager = Provider.of<UserManager>(context, listen: false);

    // 프로필 설정
    var profile = null;
    profile = NetworkImage(viewModel.user?.kakaoAccount?.profile?.profileImageUrl  ??  '');
    if(profile == null){
      profile = AssetImage('assets/poor.png');
    }

    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profile,
                  // backgroundColor: Colors.white,
                ),
                accountName: Text('${_manager.root.nickname}'),
                accountEmail: Text('Level: ${_manager.root.level}'),
                onDetailsPressed:(){
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle,
                  color: Colors.grey[850]),
              title: Text('Change Nickname'),
              onTap:(){
                Navigator.pushNamed(context, '/editnickname');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_rounded,
                  color: Colors.grey[850]),
              title: Text('Level Up'),
              onTap:(){
                Navigator.pushNamed(context, '/levelup');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout,
                  color: Colors.grey[850]),
              title: Text('Logout'),
              onTap:() async {
                await viewModel.logout();
                // setState((){});
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        )
    );
  }
}