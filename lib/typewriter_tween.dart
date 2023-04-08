import 'package:flutter/material.dart';

class StringTween extends Tween<String> {
  StringTween(String? endValue) : super(begin: '', end: endValue);

  @override
  String lerp(double t) {
    int endIndex = (t * (end?.length ?? 0)).round();
    return end?.substring(0, endIndex) ?? '';
  }
}
