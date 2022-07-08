import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week2flutter/Global/UserManager.dart';
import 'package:week2flutter/Home.dart';
import 'package:week2flutter/Market.dart';
import 'package:week2flutter/SellDelete.dart';
import 'package:week2flutter/Town.dart';
import 'package:week2flutter/Inventory.dart';

import 'Gotchya.dart';


void main() => runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserManager>(
          create: (_) => UserManager())
    ],
    child: MyApp()));  // runapp은 무조건 widget을 argument로 가져야 함

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // 커스텀 위젯은 반드시 build를 override. 또 다른 위젯을 return.
    return MaterialApp(
      title: 'JellyBuds', // 앱의 찐이름
      theme: ThemeData(
        primarySwatch: Colors.blue// 사용할 색상견본
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/market' : (context) => Market(),
        '/town': (context) => Town(),
        '/inventory': (context) => Inventory(),
        '/gotchya': (context) => Gotchya(),
        '/sellDelete': (context) => SellDelete()
      },
    );
  }
}
