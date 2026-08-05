import 'package:flutter/material.dart';
import '../../app/pages/authentication_page/forget_password_page.dart';
import '../../app/pages/authentication_page/login_page.dart';
import '../../app/pages/authentication_page/register_page.dart';
import '../../app/pages/authentication_page/verify_code_page.dart';
import '../../app/pages/introduction_page/intro_page.dart';
import '../../app/pages/introduction_page/ip_empty_state_page.dart';
import '../../app/pages/introduction_page/maintenance_page.dart';
import '../../app/pages/introduction_page/splash_page.dart';
import '../../app/pages/offline_page/internet_connection_page.dart';
import '../../app/widgets/authentication_widget/auth_wrapper.dart';

class RouteManager {
  static final publicRoutes = [
    SplashPage.pageName,
    IntroPage.pageName,
    LoginPage.pageName,
    RegisterPage.pageName,
    VerifyCodePage.pageName,
    ForgetPasswordPage.pageName,
    MaintenancePage.pageName,
    IpEmptyStatePage.pageName,
    InternetConnectionPage.pageName,
  ];

  static bool isPublicRoute(String routeName) {
    return publicRoutes.contains(routeName);
  }

  static Widget getRouteWrapper(String routeName, Widget child) {
    if (isPublicRoute(routeName)) {
      return AuthWrapper(requiresAuth: false, child: child);
    } else {
      return AuthWrapper(child: child);
    }
  }
}