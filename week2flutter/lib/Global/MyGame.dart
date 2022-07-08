import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import '../data/Malang.dart';

List<Malang> malangList = [
  Malang(type: 0, name: "플레인", imgsource: "assets/plain.gif"),
  Malang(type: 1, name: "물방울", imgsource: "assets/waterdrop.gif"),
  Malang(type: 2, name: "오로라", imgsource: "assets/ourora.gif"),
  Malang(type: 3, name: "바이러스", imgsource: "assets/vvirus.gif"),
  Malang(type: 4, name: "강아지", imgsource: "assets/puppy.gif"),
  Malang(type: 5, name: "재빠른 병아리", imgsource: "assets/fastchick.gif"),
  Malang(type: 6, name: "유니콘", imgsource: "assets/unicorn.gif"),
  Malang(type: 7, name: "플라워", imgsource: "assets/flower.gif"),
  Malang(type: 8, name: "잠탱이", imgsource: "assets/sleepy.gif"),
];

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

  @override
  Future<void> onLoad() async{
    await super.onLoad();

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
        ..size = Vector2.all(100);
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
