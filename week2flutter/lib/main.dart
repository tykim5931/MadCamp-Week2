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
import 'package:flutter/services.dart';


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
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'JellyBuds', // 앱의 찐이름
      theme: ThemeData(
        fontFamily: 'pixelfonts',
        primarySwatch: createMaterialColor(Color(0xffc973e1)),// 사용할 색상견본
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

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

