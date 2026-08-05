import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/pages/authentication_page/login_page.dart';
import '../../app/providers/user_provider.dart';

class AuthNavigation {
  static Future<void> pushProtectedRoute(
    BuildContext context, 
    String routeName,
    {Object? arguments}
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        LoginPage.pageName, 
        (route) => false
      );
      return;
    }
    
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }
}

// Usage:
// Instead of: Navigator.pushNamed(context, MainPage.pageName);
// Use: AuthNavigation.pushProtectedRoute(context, MainPage.pageName);