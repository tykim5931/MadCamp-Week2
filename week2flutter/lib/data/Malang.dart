import 'dart:ffi';
import 'package:flutter/material.dart';

class Malang {
  late String name;
  late String imgsource;
  int price = 0; // if price is zero, 경매 false
  int age = 0;
  var _created = DateTime.now();
  Malang({required this.name, required this.imgsource});

  void setPrice(int price){
    this.price = price;
  }
  void setAge(int age){
    this.age = _created.difference(DateTime.now()).inDays.toInt();
  }
}