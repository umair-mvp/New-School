import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import '../../common/data/app_data.dart';

import '../models/cart_model.dart';
import '../models/notification_model.dart';

class UserProvider extends ChangeNotifier{
  bool _isLoggedIn = false;
  String? _accessToken;
  
  bool get isLoggedIn => _isLoggedIn;
  String? get accessToken => _accessToken;
  
  ProfileModel? profile;
  setProfile(ProfileModel data){
    profile = data;
    notifyListeners();
  }


  int? userPoint;
  setPoint(int data){
    userPoint = data;
    notifyListeners();
  }


  CartModel? cartData;
  setCartData(CartModel? data){
    cartData = data;
    notifyListeners();
  }

  List<NotificationModel> notification = [];
  setNotification(List<NotificationModel> data){
    notification = data;
    notifyListeners();
  }

  

  clearAll(){
    profile = null;
    userPoint = null;
    cartData = null;
    notification.clear();
  }

    // Check login status on app start
  Future<void> checkLoginStatus() async {
    final token = await AppData.getAccessToken();
    _accessToken = token;
    _isLoggedIn = token.isNotEmpty;
    notifyListeners();
  }
  
  // Login method
  Future<void> login(String token) async {
    await AppData.saveAccessToken(token);
    _accessToken = token;
    _isLoggedIn = true;
    notifyListeners();
  }
  
  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _accessToken = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}