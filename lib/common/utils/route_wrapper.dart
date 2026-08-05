import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/user_provider.dart';
import '../../app/pages/authentication_page/login_page.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  
  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    if (!userProvider.isLoggedIn) {
      // Redirect to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          LoginPage.pageName, 
          (route) => false
        );
      });
      
      // Show loading or empty widget while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return child;
  }
}