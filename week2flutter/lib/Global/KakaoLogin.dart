import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:provider/provider.dart';



abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
}

class KakaoLogin implements SocialLogin{
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      }
      else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try{
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}

class ViewModel with ChangeNotifier{
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;
  ViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined){
      user = await UserApi.instance.me();
    }
  }
  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}
