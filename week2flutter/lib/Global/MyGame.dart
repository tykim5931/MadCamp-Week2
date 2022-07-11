import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:provider/provider.dart';

import '../data/Malang.dart';
import 'UserManager.dart';

import '../data/instances.dart';

import '../server.dart' as serverUtils;


class Slime{
  int? type;
  double? speed;
  SpriteAnimationComponent slime = SpriteAnimationComponent();
  int dir = 0; // path[dir]
  int dist = 50; // dist만큼의 거리를 이동할 예정

  Slime(int type){
    this.type = type;
    this.speed = 1.0; // SLIMETYPE[type]!["speed"];
  }
}

late UserManager _manager;

class MyGame extends FlameGame with HasTappables{
  late SpriteAnimation rightAnimation;
  late SpriteAnimation leftAnimation;
  var slimeList = <Slime>[];
  var spList = <SpriteSheet>[];
  var rAList = <SpriteAnimation>[]; // 오른쪽 애니메이션들 모음
  var lAList = <SpriteAnimation>[]; // 왼쪽 애니메이션들 모음
  var path = [[1, 0], [0, 1], [-1, 0], [0, -1]]; // 방향

  SpriteAnimationComponent slime = SpriteAnimationComponent();
  var pointText = TextComponent();
  var diaText = TextComponent();
  BuildContext context;
  List<Malang> malangList;

  // GemBox
  var gemboxlist = <GemBox>[];
  final Vector2 buttonSize = Vector2(40,40);

  ParallaxComponent bush = ParallaxComponent();

  MyGame({required this.context, required this.malangList});

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    _manager = Provider.of<UserManager>(context, listen: false);

    ////////// BACKGROUND //////////////
    double maxSide = max(size.x, size.y);
    String imgsource = USERLEVEL[_manager.selected.level]!["imgsource"];
    BackGroundComponent background = BackGroundComponent(malangList)
      ..sprite = await loadSprite(imgsource)
      ..center = Vector2(-70, 0)
      ..size = Vector2(maxSide -100 , maxSide);
    add(background);

    ////////// slime list //////////////
    for(int i=0; i<SLIMETYPE.length; i++) {
      spList.add(SpriteSheet(
          image: await images.load(SLIMETYPE[i]!['imgsource']),
          srcSize: Vector2(128, 145)));
      rAList.add(spList[i].createAnimation(row: 0, stepTime: 0.5, to: 2));
      lAList.add(spList[i].createAnimation(row: 1, stepTime: 0.5, to: 2));
    }
    for(Malang item in malangList){
      slimeList.add(Slime(item.getType())); // Slime(종류, 속도)
    }
    for(int i=0; i < slimeList.length; i++){
      slimeList[i].slime = SpriteAnimationComponent()
        ..animation = rAList[slimeList[i].type ?? 0]
        ..x = Random().nextDouble()*300
        ..y = Random().nextDouble()*500
        ..size = Vector2.all(80);
      add(slimeList[i].slime);
    }

    //////////////// Point Component ///////////////
    pointText = TextComponent(
        text: "\u{1F4B0} ${_manager.root.point.toString()}",
        textRenderer: TextPaint(
            style: TextStyle(
              color: BasicPalette.white.color,
              fontSize: 25,
              fontFamily: 'pixelfonts',
            )
        ))
      ..anchor = Anchor.topLeft
      ..x = 30.0
      ..y = 30.0;
    diaText = TextComponent(
        text: "\u{1F48E} ${_manager.root.dia.toString()}",
        textRenderer: TextPaint(
            style: TextStyle(
              color: BasicPalette.white.color,
              fontSize: 25,
              fontFamily: 'pixelfonts',
            )
        ))
      ..anchor = Anchor.topLeft
      ..x = 30.0
      ..y = 70.0;

    if(_manager.root.id == _manager.selected.id){
      add(pointText);
      add(diaText);
    }

    // gembox
    List<double> pos = [size[0]-60, 40, size[0]/2, size[1]/2-10, size[0]-80, size[1]-150];
    int poschoose = Random().nextInt(3);
    if(_manager.root.currentdia < 10){
      int gemcount = min(3, Random().nextInt(10 - _manager.root.currentdia));  // 그날 모은 다이아 개수보다 작게 생성함!!
      for (int i = 0; i < gemcount; i++){
        GemBox gemBox = GemBox()
          ..sprite = await loadSprite('gembox.png')
          ..size = buttonSize
          ..position = Vector2(pos[poschoose*2], pos[poschoose*2+1]);
        gemboxlist.add(gemBox);
      }
    }
    for(int i=0; i < gemboxlist.length; i++){
      add(gemboxlist[i]);
    }
  }

  @override
  void update(double dt){
    super.update(dt);

    UserManager _manager = Provider.of<UserManager>(context, listen: false);

    ////////////// Slimes //////////////////
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

    /////////////////// point Text //////////////////////
    pointText.text = "\u{1F4B0} ${_manager.root.point.toString()}";
    diaText.text = "\u{1F48E} ${_manager.root.dia.toString()}";

    ///// gembox /////
    for(int i=0; i < gemboxlist.length; i++){
      if(gemboxlist[i].tabbed){
        gemboxlist[i].removeFromParent();
        gemboxlist.removeAt(i);
      }
    }
  }
  
  
}

class BackGroundComponent extends SpriteComponent with Tappable {
  var malangList;
  BackGroundComponent(this.malangList);
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      if (_manager.selected.id == _manager.root.id) {
        var future = serverUtils.requireUser(_manager.root.id);
        future.then((val) {
          _manager.root = val[0]; // 중간에 다른 유저가 매물을 사면서 내 포인트가 늘어나게 되는 상황 대비!!
          _manager.root.addPoint(calcPoint(malangList));
          serverUtils.updateUser(_manager.root);
        }).catchError((error) {
          print('error: $error');
        });
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

class GemBox extends SpriteComponent with Tappable {
  bool tabbed = false;
  @override
  bool onTapDown(TapDownInfo event){
    try{

      var future = serverUtils.requireUser(_manager.root.id);
      future.then((val) {

        _manager.root = val[0]; // 중간에 다른 유저가 매물
        _manager.root.dia = _manager.root.dia + 1;
        _manager.root.currentdia = _manager.root.currentdia + 1;
        serverUtils.updateUser(_manager.root);

      }).catchError((error) {
        print('error: $error');
      });

      print("randomly give gem or not!");
      this.tabbed = true;
      return true;

    } catch(error){
      print(error);
      return false;
    }
  }
}

int calcPoint(List<Malang> malanglist) {
  int point = 0;
  if (malanglist.isEmpty)
    return 1;
  for (int i = 0; i < malanglist.length; i++) {
    point = point + ((malanglist[i].type) ~/ 3 + 1); // 3개씩 같은 레벨.
  }
  return point;
}