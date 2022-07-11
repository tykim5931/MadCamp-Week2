import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/EditNickname.dart';
import 'package:week2flutter/Global/KakaoLogin.dart';
import 'package:week2flutter/Global/UserManager.dart';
import 'package:week2flutter/Home.dart';
import 'package:week2flutter/Market.dart';
import 'package:week2flutter/SellDelete.dart';
import 'package:week2flutter/Town.dart';
import 'package:week2flutter/Inventory.dart';
import 'Gotchya.dart';
import 'LevelUp.dart';
import 'Login.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'Global/KakaoLogin.dart';



void main() {
  KakaoSdk.init(nativeAppKey: '0ddac530e20dcf349f1927aaf2c331ab');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>(
            create: (_) => UserManager()),
        ChangeNotifierProvider<ViewModel>(
          create: (_) => ViewModel(KakaoLogin()),
        )
      ],
      child: MyApp()));
}  // runapp은 무조건 widget을 argument로 가져야 함

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // 커스텀 위젯은 반드시 build를 override. 또 다른 위젯을 return.
    return MaterialApp(
      title: 'JellyBuds', // 앱의 찐이름
      theme: ThemeData(
        primarySwatch: Colors.blue// 사용할 색상견본
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => Home(),
        '/market' : (context) => Market(),
        '/town': (context) => Town(),
        '/inventory': (context) => Inventory(),
        '/gotchya': (context) => Gotchya(),
        '/sellDelete': (context) => SellDelete(),
        '/login' : (context) => Login(),
        '/editnickname' : (context) => EditNickname(),
        '/levelup' : (context) => LevelUp()
      },
    );
  }
}
