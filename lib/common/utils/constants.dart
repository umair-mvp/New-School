import 'package:flutter/material.dart';

class Constants {
  // static const dommain = 'http://10.0.2.2:8000';
  static const String dommain = '';
  static const baseUrl = '$dommain/api/development/';
  static const apiKey = '4416';
  static const scheme = 'newschool';

  static final RouteObserver<ModalRoute<void>> singleCourseRouteObserver =
      RouteObserver<ModalRoute<void>>();
  static final RouteObserver<ModalRoute<void>> contentRouteObserver =
      RouteObserver<ModalRoute<void>>();
}
