import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:provider/provider.dart';

import '../data/Malang.dart';
import 'UserManager.dart';


Map<int, List<String>> slimeType =
{ 0: ["플레인", "assets/plain.gif"],
  1: ["물방울","assets/waterdrop.gif"],
  2: ["오로라","assets/ourora.gif"],
  3: ["바이러스","assets/vvirus.gif"],
  4: ["강아지","assets/puppy.gif"],
  5: ["재빠른병아리","assets/fastchick.gif"],
  6: ["유니콘","assets/unicorn.gif"],
  7: ["플라워","assets/flower.gif"],
  8: ["잠탱이","assets/sleepy.gif"]
};

List<double> speedList = [1, 0.5, 1, 1, 3, 1, 1, 1, 1];

class Slime{
  int? type;
  double? speed;
  SpriteAnimationComponent slime = SpriteAnimationComponent();
  int dir = 0; // path[dir]
  int dist = 50; // dist만큼의 거리를 이동할 예정

  Slime(int type){
    this.type = type;
    this.speed = speedList[type];
  }
}


class MyGame extends FlameGame{
  late SpriteAnimation rightAnimation;
  late SpriteAnimation leftAnimation;
  var slimeList = <Slime>[];
  var spList = <SpriteSheet>[];
  var rAList = <SpriteAnimation>[]; // 오른쪽 애니메이션들 모음
  var lAList = <SpriteAnimation>[]; // 왼쪽 애니메이션들 모음
  var path = [[1, 0], [0, 1], [-1, 0], [0, -1]]; // 방향
  //SpriteComponent slime = SpriteComponent();
  SpriteAnimationComponent slime = SpriteAnimationComponent();
  var pointText = TextComponent();
  BuildContext context;
  List<Malang> malangList;

  MyGame({required this.context, required this.malangList});

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    pointText = TextComponent(text: "Point: ${_manager.root.point.toString()}", textRenderer: TextPaint(style: TextStyle(color: BasicPalette.white.color)))
      ..anchor = Anchor.topLeft
      ..x = 100.0
      ..y = 30.0;

    add(pointText);

    //print('load game assets');
    // spriteSheet for image 0
    for(int i=0; i<9; i++){
      spList.add(SpriteSheet(image: await images.load('slime_${i}.png'),srcSize: Vector2(128, 145)));
      rAList.add(spList[i].createAnimation(row:0, stepTime:0.5, to: 2));
      lAList.add(spList[i].createAnimation(row:1, stepTime:0.5, to: 2));
    }

    // spList[0] -> 기존 SpriteSheet
    //rightAnimation = spriteSheet.createAnimation(row:0, stepTime:0.3, to: 2);
    //leftAnimation = spriteSheet.createAnimation(row:1, stepTime:0.3, to: 2);
    /////////////////////////////////////

    for(Malang item in malangList){
      slimeList.add(Slime(item.getType())); // Slime(종류, 속도)
    }

    for(int i=0; i < slimeList.length; i++){
      slimeList[i].slime = SpriteAnimationComponent()
        ..animation = rAList[slimeList[i].type ?? 0]
        ..x = Random().nextDouble()*300
        ..y = Random().nextDouble()*500
        ..size = Vector2.all(50);
      add(slimeList[i].slime);
    }

    //slime = SpriteAnimationComponent()
    //  ..animation = rightAnimation
    //  ..position = Vector2.all(100)
    //  ..size = Vector2.all(100);
    //add(slime);
    //////////////////////////////

  }

  @override
  void update(double dt){
    super.update(dt);

    UserManager _manager = Provider.of<UserManager>(context, listen: false);
    pointText.text = "Point: ${_manager.root.point.toString()}";

    for(int i=0; i < slimeList.length; i++){
      SpriteAnimationComponent slime = slimeList[i].slime;
      if(slimeList[i].dist<0){
        slimeList[i].dir = Random().nextInt(4);
        if(slimeList[i].dir==0){
          slime.animation = rAList[slimeList[i].type ?? 0]; // 왼쪽무빙
        }
        if(slimeList[i].dir==2){
          slime.animation = lAList[slimeList[i].type ?? 0]; // 오른쪽무빙
        }
        slimeList[i].dist=(Random().nextDouble()*100).toInt();
      }
      else{
        if(slime.x>size.x-10){
          slime.x-=1;
          slimeList[i].dist = 0;
        }
        else if(slime.x<10){
          slime.x+=1;
          slimeList[i].dist = 0;
        }
        else if(slime.y<10){
          slime.y+=1;
          slimeList[i].dist = 0;
        }
        else if(slime.y>size.y-10){
          slime.y-=1;
          slimeList[i].dist = 0;
        }
        else {
          slime.x += path[slimeList[i].dir][0];
          slime.y += path[slimeList[i].dir][1];
          slimeList[i].dist -= 1;
        }
      }
    }
  }
}
