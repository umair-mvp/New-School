import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages/authentication_page/login_page.dart';
import '../../providers/user_provider.dart';
import '../../../common/data/app_data.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;
  final bool requiresAuth;
  
  const AuthWrapper({
    super.key,
    required this.child,
    this.requiresAuth = true,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Check if user has access token
    final token = await AppData.getAccessToken();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    setState(() {
      _isAuthenticated = token.isNotEmpty && userProvider.isLoggedIn;
      _isCheckingAuth = false;
    });

    // If not authenticated and requires auth, redirect to login
    if (!_isAuthenticated && widget.requiresAuth && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          LoginPage.pageName, 
          (route) => false
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (_isCheckingAuth && widget.requiresAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If doesn't require auth or is authenticated, show child
    if (!widget.requiresAuth || _isAuthenticated) {
      return widget.child;
    }

    // Return empty container if not authenticated (will redirect)
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}