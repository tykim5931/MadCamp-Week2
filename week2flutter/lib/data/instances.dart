

import 'dart:ui';

import 'package:flutter/material.dart';

final Map<int, Map<String, dynamic>> USERLEVEL =
{ // inventory size, price, backgroundimg 경로
  1: {"inventory": 3, "price": 0, "imgsource": "background_1.png","thumbnail": "assets/images/thumbnail_1.png",
      "probalist": [9,1,0,0]},
  2: {"inventory": 5, "price": 300, "imgsource": "background_2.png","thumbnail": "assets/images/thumbnail_2.png",
      "probalist": [80,19,1,0]},
  3: {"inventory": 7, "price": 1000, "imgsource": "background_3.png","thumbnail": "assets/images/thumbnail_3.png",
      "probalist": [72,25,3,0]},
  4: {"inventory": 9, "price": 3000, "imgsource": "background_4.png","thumbnail": "assets/images/thumbnail_4.png",
      "probalist": [64,30,5,1]},
  5: {"inventory": 11, "price": 10000, "imgsource": "background_5.png","thumbnail": "assets/images/thumbnail_5.png",
      "probalist": [57,34,7,2]},
  6: {"inventory": 14, "price": 30000, "imgsource": "background_6.png","thumbnail": "assets/images/thumbnail_6.png",
      "probalist": [52,35,10,3]},
  7: {"inventory": 17, "price": 100000, "imgsource": "background_7.png","thumbnail": "assets/images/thumbnail_7.png",
      "probalist": [45,35,15,5]},
  8: {"inventory": 20, "price": 200000, "imgsource": "background_8.png","thumbnail": "assets/images/thumbnail_8.png",
      "probalist": [37,35,20,8]},
  9: {"inventory": 25, "price": 999999, "imgsource": "background_9.png","thumbnail": "assets/images/thumbnail_9.png",
      "probalist": [30,35,25,10]},
};

final Map<int, Map<String, dynamic>> SLIMETYPE =
{ // 종족, gif경로, 애니메이션그림경로, speed
  0: {"species" : "플레인", "gifsource": "assets/plain.gif",
      "imgsource": 'slime_0.png', "speed": 1.0},
  1: {"species" : "물방울", "gifsource": "assets/waterdrop.gif",
      "imgsource": 'slime_1.png', "speed": 1.0},
  2: {"species" : "오로라", "gifsource": "assets/ourora.gif",
      "imgsource": 'slime_2.png', "speed": 1.0},
  3: {"species" : "바이러스", "gifsource": "assets/vvirus.gif",
      "imgsource": 'slime_3.png', "speed": 1.0},
  4: {"species" : "강아지", "gifsource": "assets/puppy.gif",
    "imgsource": 'slime_4.png', "speed": 1.0},
  5: {"species" : "재빠른병아리", "gifsource": "assets/fastchick.gif",
    "imgsource": 'slime_5.png', "speed": 1.0},
  6: {"species" : "유니콘", "gifsource": "assets/unicorn.gif",
    "imgsource": 'slime_6.png', "speed": 1.0},
  7: {"species" : "플라워", "gifsource": "assets/flower.gif",
    "imgsource": 'slime_7.png', "speed": 1.0},
  8: {"species" : "잠꾸러기", "gifsource": "assets/sleepy.gif",
    "imgsource": 'slime_8.png', "speed": 1.0},
  9: {"species" : "킹슬라임", "gifsource": "assets/king.gif",
    "imgsource": 'slime_9.png', "speed": 1.0},
  10: {"species" : "천사", "gifsource": "assets/angel.gif",
    "imgsource": 'slime_10.png', "speed": 1.0},
  11: {"species" : "넙죽이", "gifsource": "assets/kaist.gif",
    "imgsource": 'slime_11.png', "speed": 1.0},
};

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