import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';




class Slime{
  int? type;
  double? speed;
  SpriteAnimationComponent slime = SpriteAnimationComponent();
  int dir = 0; // path[dir]
  int dist = 50; // dist만큼의 거리를 이동할 예정

  Slime(int type, double speed){
    this.type = type;
    this.speed = speed;
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
    spList.add(SpriteSheet(image: await images.load('slime_0.png'),srcSize: Vector2(128, 145)));
    rAList.add(spList[0].createAnimation(row:0, stepTime:0.5, to: 2));
    lAList.add(spList[0].createAnimation(row:1, stepTime:0.5, to: 2));

    spList.add(SpriteSheet(image: await images.load('slime_1.png'),srcSize: Vector2(128, 140)));
    rAList.add(spList[1].createAnimation(row:0, stepTime:0.5, to: 2));
    lAList.add(spList[1].createAnimation(row:1, stepTime:0.5, to: 2));

    // spList[0] -> 기존 SpriteSheet
    //rightAnimation = spriteSheet.createAnimation(row:0, stepTime:0.3, to: 2);
    //leftAnimation = spriteSheet.createAnimation(row:1, stepTime:0.3, to: 2);
    /////////////////////////////////////


    slimeList.add(Slime(1, 1)); // Slime(종류, 속도)
    slimeList.add(Slime(1, 1));
    slimeList.add(Slime(1, 0.5));
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
